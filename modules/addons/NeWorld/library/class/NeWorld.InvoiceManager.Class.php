<?php
// 声明命名空间
namespace NeWorld;

// 引入文件
require_once __DIR__.'/NeWorld.Common.Class.php';

// 使用其他的类
use \Exception;

if (!class_exists('InvoiceManager'))
{
    class InvoiceManager
    {
        private $data;
        private $extend;

        public function __construct()
        {
            // 实例化数据库类
            $this->data = new Database();

            // 实例化扩展类
            $this->extend = new Extended();
        }

        // 自动返回类
        public function __call($className = '', array $params = [])
        {
            // 类名
            $className = '\\NeWorld\\'.$className;

            // 判断类名是否存在
            if (!class_exists($className)) throw new Exception('发票管理系统不存在 '.$className.' 类');

            // 将数据库类加入数组
            $params['data'] = $this->data;

            // 将扩展类加入数组
            $params['extend'] = $this->extend;

            // 如果存在用户 ID、那么把用户 ID 加入数组
            !empty($_SESSION['uid']) AND $params['userid'] = $_SESSION['uid'];

            // 实例化类并且返回
            return new $className($params);
        }

        // 返回模块方法
        public function template(array $template = [])
        {
            // 设置目录
            $template['dir'] = ROOTDIR.'/modules/addons/invoiceManager/templates/';

            return $this->extend->getSmarty($template);
        }
    }
}

// 通用类
if (!class_exists('common'))
{
    class common
    {
        private $params;

        public function __construct(array $params = [])
        {
            // 判断是否为空
//            if (empty($params) || empty($params['userid'])) throw new Exception('尚未传递信息');

            // 将抬头信息赋值给属性
            $this->params = (object) $params;
        }

        // 返回通知
        public function tips($tips = '', $content = '')
        {
            //
            if (empty($tips) || empty($content)) throw new Exception('请输入正确的通知信息');

            return $this->params->extend->getSmarty([
                'dir' => ROOTDIR.'/modules/addons/invoiceManager/templates/tips/',
                'file' => $tips,
                'vars' => [
                    'message' => $content,
                ],
            ]);
        }

        // 返回用户抬头和地址、待开快递的发票等信息
        public function userInfo($userID = '')
        {
            $userID = empty($_GET['id']) ? $userID : $_GET['id'];

            if (empty($userID)) throw new Exception('当前尚未传递需要获取详情的用户编号');

            // 获取信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'title' => [
                        'sql' => "SELECT * FROM vati_title WHERE userid = ? AND status = 'success'",
                        'pre' => [$userID],
                        'all' => true,
                    ],
                    'address' => [
                        'sql' => 'SELECT * FROM vati_address WHERE userid = ?',
                        'pre' => [$userID],
                        'all' => true,
                    ],
                    'invoice' => [
                        'sql' => "SELECT * FROM vati_invoice WHERE userid = ? AND status = 'success'",
                        'pre' => [$userID],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            $result = [
                'title' => $getData['title']['result'],
                'address' => $getData['address']['result'],
                'invoices' => $getData['invoice']['result'],
            ];

            foreach ($result['invoices'] as $key => $value)
            {
                // 检查是否已开快递
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'check' => [
                            'sql' => 'SELECT id FROM vati_express_record WHERE invoice = ?',
                            'pre' => [$value],
                        ],
                    ],
                ]);

                if (!empty($getData['check']['result'])) unset($result['invoices'][$key]);
                else $result['invoices'][$key]['address'] = json_decode($value['address'], true);
            }

            return $result;
        }

        // 返回价格
        public function sumAmount()
        {
//            // 读取地址信息
//            $getDta = $this->params->data->runSQL([
//                'action' => [
//                    'address' => [
//                        'sql' => 'SELECT province FROM vati_address WHERE id = ?',
//                        'pre' => [$_GET['address']],
//                    ],
//                ],
//                'trans' => false,
//            ]);
//
//            if (empty($getDta['address']['result']['province'])) throw new Exception('无法取得地址编号 #'.$_GET['address'].' 的省市信息');

            // 读取省市的价格
            $getData = $this->params->data->runSQL([
                'action' => [
                    'price' => [
                        'sql' => 'SELECT price FROM vati_express_price WHERE express = ? AND province = ?',
                        'pre' => [$_GET['express'], $_GET['province']],
                    ],
                ],
                'trans' => false,
            ]);

            $price = empty($getData['price']['result']['price']) ? '' : $getData['price']['result']['price'];

            // 如果为空的话使用默认价格
            if (empty($price))
            {
                //
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'price' => [
                            'sql' => 'SELECT price FROM vati_express WHERE id = ?',
                            'pre' => [$_GET['express']],
                        ],
                    ],
                    'trans' => false,
                ]);

                $price = $getData['price']['result']['price'];
            }

            return $price;
        }

        //
    }
}

// 快递类
if (!class_exists('express'))
{
    class express
    {
        private $params;

        public function __construct(array $params = [])
        {
            // 判断是否为空
//            if (empty($params) || empty($params['userid'])) throw new Exception('尚未传递快递信息');

            // 将抬头信息赋值给属性
            $this->params = (object) $params;
        }

        // 发件信息
        public function sendInfo()
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'companyName' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'companyName'",
                    ],
                    'expressName' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'expressName'",
                    ],
                    'expressAddress' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'expressAddress'",
                    ],
                    'expressPhone' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'expressPhone'",
                    ],
                ],
                'trans' => false,
            ]);

            $result = [
                'name' => 'expressName',
                'company' => 'companyName',
                'phone' => 'expressPhone',
                'address' => 'expressAddress',
            ];

            foreach ($result as $key => $value)
            {
                $result[$key] = $getData[$value]['result']['value'];
            }

            return $result;
        }

        // 返回已开票但是无快递的信息
        public function getExpressInvoice()
        {
            // 获取信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'invoice' => [
                        'sql' => "SELECT * FROM vati_invoice WHERE status = 'success'",
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            $result = $getData['invoice']['result'];

            foreach ($result as $key => $value)
            {
                // 检查是否已开快递
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'check' => [
                            'sql' => 'SELECT id FROM vati_express_record WHERE invoice = ?',
                            'pre' => [$value['id']],
                        ],
                    ],
                ]);

                if (!empty($getData['check']['result'])) unset($result[$key]);
                else $result[$key]['address'] = json_decode($value['address'], true);
            }

            return $result;
        }

        // 获取记录
        public function getRecord()
        {
            // 获取数据库
            $getData = $this->params->data->runSQL([
                'action' => [
                    'record' => [
                        'sql' => 'SELECT * FROM vati_express_record WHERE userid = ?',
                        'pre' => [$this->params->userid],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            // 判断是否为空
            if (empty($getData['record']['result'])) throw new Exception('当前账户下没有快递记录');

            $result = $getData['record']['result'];

            foreach ($result as $key => $value)
            {
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'express' => [
                            'sql' => 'SELECT name FROM vati_express WHERE id = ?',
                            'pre' => [$value['express']],
                        ],
                    ],
                    'trans' => false,
                ]);

                $result[$key]['expressName'] = $getData['express']['result']['name'];
            }

            // 返回结果
            return $result;
        }

        // 新快递
        public function newExpress()
        {
            $params = [
                'userid' => '用户编号',
//                'addressid' => '地址信息',
                'expressid' => '快递信息',
                'expressnum' => '运单编号',
                'expressname' => '项目名称',
                'amount' => '快递价格',
            ];

            foreach ($params as $key => $value)
            {
                if (empty($_POST[$key])) throw new Exception('缺少 '.$value.' 信息，请重新开快递');
            }

            $userID = $_POST['userid']; $express = $_POST['expressid'];
            $code = $_POST['expressnum']; $name = $_POST['expressname']; $amount = $_POST['amount'];

            if (!empty($_POST['invoice']))
            {
                // 查地址
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'invoice' => [
                            'sql' => 'SELECT address FROM vati_invoice WHERE id = ?',
                            'pre' => [$_POST['invoice']],
                        ],
                    ],
                    'trans' => false,
                ]);

                if (empty($getData['invoice']['result'])) throw new Exception('系统中未寻找到 ID 编号为 #'.$_POST['invoice'].' 的地址信息');

                $address = $getData['invoice']['result']['address'];
            }
            else
            {
                // 查地址
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'address' => [
                            'sql' => 'SELECT * FROM vati_address WHERE id = ?',
                            'pre' => [$_POST['addressid']],
                        ],
                    ],
                    'trans' => false,
                ]);

                if (empty($getData['address']['result'])) throw new Exception('系统中未寻找到 ID 编号为 #'.$_POST['addressid'].' 的地址信息');

                $address = json_encode($getData['address']['result']);
            }

            $getData = $this->params->data->runSQL([
                'action' => [
                    'express' => [
                        'sql' => 'INSERT INTO vati_express_record (userid,express,invoice,name,address,code,amount) VALUES (?,?,?,?,?,?,?)',
                        'pre' => [$userID, $express, empty($_POST['invoice']) ? '' : $_POST['invoice'],$name, $address, $code, $amount],
                    ],
                ],
            ]);

            if ($getData['express']['rows'] != 1) throw new Exception('快递信息添加失败，请检查是否运单已存在');

            $getData = $this->params->data->runSQL([
                'action' => [
                    'id' => [
                        'sql' => 'SELECT id FROM vati_express_record WHERE code = ?',
                        'pre' => [$code],
                    ],
                ],
                'trans' => false,
            ]);

            return $getData['id']['result']['id'];
        }

        // 获取快递内容
        public function track($code, $express)
        {
            // 拼接请求数据
            $requestData= "{'OrderCode':'','ShipperCode':'{$code}','LogisticCode':'{$express}'}";

            // 查询快递
            $query = $this->params->extend->getWebPage([
                'url' => 'http://api.kdniao.cc/Ebusiness/EbusinessOrderHandle.aspx',
                'post' => [
                    'EBusinessID' => '1269882',
                    'RequestType' => '1002',
                    'RequestData' => urlencode($requestData) ,
                    'DataType' => '2',
                    'DataSign' => urlencode(base64_encode(md5($requestData.'f1f2e8ee-f197-4d98-a01e-c48783605103'))),
                ],
                'type' => 'json',
                'time' => 30, // 设置 30 秒才超时
            ]);

            // 判断是否为空
            if (empty($query)) throw new Exception('快递信息查询失败，请稍候重试');

            // 判断是否存在 Reason
            if (!empty($query['Reason'])) throw new Exception('快递查询失败，因为'.$query['Reason']);

            // 倒序处理
            arsort($query['Traces']);

            // 返回查询到的信息
            return $query['Traces'];
        }

        // 获取快递设置
        public function getExpressSetting()
        {
            //
            $getData = $this->params->data->runSQL([
                'action' => [
                    'setting' => [
                        'sql' => 'SELECT * FROM vati_express',
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['setting']['result'])) return false;
            else return $getData['setting']['result'];
        }

        // 获取快递区域价格
        public function getExpressPrice()
        {
            //
            $getData = $this->params->data->runSQL([
                'action' => [
                    'price' => [
                        'sql' => 'SELECT * FROM vati_express_price WHERE express = ? ORDER BY orderby',
                        'pre' => [$_GET['id']],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['price']['result'])) return false;
            else return $getData['price']['result'];
        }

        // 修改快递价格
        public function changeExpressPrice()
        {
            if (empty($_POST['price'])) throw new Exception('当前尚未传递价格信息');

            foreach ($_POST['price'] as $key => $value)
            {
                if ($key == 0) continue;

                $params = [
//                    'orderby' => '区域排序',
                    'province' => '省市或地区',
                    'price' => '区域价格',
                    'status' => '价格启用状态',
                ];

                foreach ($params as $k => $v)
                {
                    //
                    if (empty($value[$k])) throw new Exception('区域设置缺少传递值，请返回检查某条区域设置中是否有信息尚未填写 '.$v.' 信息');
                }
            }

            $query = [];
            // 重新遍历数组开始写入
            foreach ($_POST['price'] as $key => $value)
            {
                // 检查
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'check' => [
                            'sql' => 'SELECT id FROM vati_express_price WHERE province = ? AND express = ?',
                            'pre' => [$value['province'], $_POST['id']],
                        ],
                    ],
                ]);

                if ($key == 0)
                {
                    if (empty($value['province']) || empty($value['price'])) continue;

                    if (!empty($getData['check']['result'])) throw new Exception('当前需要插入的 '.$value['province'].' 已存在，请重新设置');

                    $query[$key] = [
                        'sql' => 'INSERT INTO vati_express_price (orderby,express,province,price,status) VALUES (?,?,?,?,?)',
                        'pre' => [empty($value['orderby']) ? 0 : $value['orderby'], $_POST['id'], $value['province'], $value['price'], $value['status']],
                    ];
                }
                else
                {
                    if ($getData['check']['result']['id'] != $key) throw new Exception('当前需要更新的 '.$value['province'].' 已存在，请重新设置');

                    $query[$key] = [
                        'sql' => 'UPDATE vati_express_price SET orderby = ? , province = ? , price = ? , status = ? WHERE id = ?',
                        'pre' => [empty($value['orderby']) ? 0 : $value['orderby'], $value['province'], $value['price'], $value['status'], $key],
                    ];
                }
            }

            // 写入快递价格
            $this->params->data->runSQL([
                'action' => $query,
            ]);
        }

        // 更新快递信息
        public function update()
        {
            //
            $params = [
                'id' => '需要修改条目的 ID 编号',
                'name' => '项目名称',
                'code' => '运单编号',
                'amount' => '运单价格',
                'express' => '快递编号',
            ];

            foreach ($params as $key => $value)
            {
                if (empty($_POST[$key])) throw new Exception('当前修改的信息中尚未传递 '.$value.' 信息，请返回重新修改');
            }

            $id = $_POST['id']; $name = $_POST['name']; $code = $_POST['code'];
            $amount = $_POST['amount']; $express = $_POST['express'];

            $getData = $this->params->data->runSQL([
                'action' => [
                    'update' => [
                        'sql' => 'UPDATE vati_express_record SET name = ? , code = ? , amount = ? , express = ? WHERE id = ?',
                        'pre' => [$name, $code, $amount, $express, $id],
                    ],
                ],
            ]);

            if ($getData['update']['rows'] != 1) throw new Exception('快递信息修改失败，请重新尝试');
        }

        // 修改快递设置
        public function changeExpress()
        {
            if (empty($_POST['express'])) throw new Exception('当前尚未设置任何信息，请重新设置');

            // 检查数组是否正常
            foreach ($_POST['express'] as $key => $value)
            {
                if ($key == 0) continue;

                $params = [
                    'name' => '快递名称',
                    'code' => '快递代码',
                    'price' => '快递默认价格',
                    'status' => '快递启用状态',
                ];

                foreach ($params as $k => $v)
                {
                    if (empty($value[$k])) throw new Exception('快递缺少传递值，请返回检查是否某条快递记录未填写（或未传递） '.$v.' 信息');
                }
            }

            // 重新遍历数组
            foreach ($_POST['express'] as $key => $value)
            {
                // 判断键是否 0，如果是 0 则说明是新记录
                if ($key == 0)
                {
                    if (empty($value['name']) || empty($value['code']) || empty($value['price'])) continue;

                    $query = [
                        'sql' => 'INSERT INTO vati_express (name,code,price,status) VALUES (?,?,?,?)',
                        'pre' => [$value['name'], strtoupper($value['code']), $value['price'], $value['status']],
                    ];
                }
                else
                {
                    $query = [
                        'sql' => 'UPDATE vati_express SET name = ? , code = ? , price = ? , status = ? WHERE id = ?',
                        'pre' => [$value['name'], strtoupper($value['code']), $value['price'], $value['status'], $key],
                    ];
                }

                try
                {
                    // 写入快递
                    $this->params->data->runSQL([
                        'action' => [
                            'query' => $query,
                        ],
                    ]);
                }
                catch (Exception $e)
                {
                    continue;
                }
            }
        }

        // 删除快递信息
        public function delete()
        {
            //
            $getData = $this->params->data->runSQL([
                'action' => [
                    'delete' => [
                        'sql' => 'DELETE FROM vati_express WHERE id = ?',
                        'pre' => [$_GET['id']],
                    ],
                ],
            ]);

            if ($getData['delete']['rows'] != 1) throw new Exception('快递信息删除失败，请重试');
        }

        // 删除快递价格
        public function deletePrice()
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'delete' => [
                        'sql' => 'DELETE FROM vati_express_price WHERE id = ?',
                        'pre' => [$_GET['delete']],
                    ],
                ],
            ]);

            if ($getData['delete']['rows'] != 1) throw new Exception('快递信息删除失败，请重试');
        }

        // 获取全部快递信息
        public function getAll()
        {
            // 默认开启上下页
            $previous = true; $next = true;
            
            $getData = $this->params->data->runSQL([
                'action' => [
                    'count' => [
                        'sql' => 'SELECT count(*) FROM vati_express_record',
                    ],
                    'page' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'dataCount'",
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['count']['result'])) throw new Exception('数据库中没有快递记录');

            // 数据记录总条数
            $dataCount = current($getData['count']['result']);

            // 页面数据条数
            $pageDataCount = $getData['page']['result']['value'];

            // 计算总页数，以 . 分割为数组、以便下方检测是否小数
            $pageCount = $dataCount / $pageDataCount; $pageCountArray = explode('.', $pageCount);

            // 判断是否小数，如果是小数的话加一页(例如: 16 条数据，以 5 条为一页、那么有 4 页数据)
            if (isset($pageCountArray['1'])) $pageCount = $pageCountArray['0'] + 1;

            // 当前页码
            $pageNum = empty($_GET['pagenum']) ? 1 : (int) $_GET['pagenum'];

            // 如果总页数小于每页条数，那么就隐藏上下页
            if ($dataCount <= $pageDataCount)
            {
                $previous = false; $next = false;
            }
            else if ($pageNum + 1 > $pageCount)
            {
                $next = false;
            }
            else if ($pageNum - 1 < 1)
            {
                $previous = false;
            }

            // 获取取出数据的起点，并且判断是否指定正序输出(默认倒序)
            $startNum = ($pageNum - 1) * $pageDataCount; $sort = isset($_GET['asc']) ? 'ASC' : 'DESC';

            // 正则匹配纯英文字母的 field 并且赋值给变量
            preg_match('/[a-zA-Z]+/', empty($_GET['orderby']) ? 'id' : (string) htmlentities($_GET['orderby']), $matches);

            // 将正则匹配出的纯字符赋值给变量，此时获取到的 field 已经是纯字母、避免下面 SQL 注入的问题
            $sortField = $matches['0']; if (empty($sortField)) throw new Exception('排序字段仅允许传递纯字母');

            // 获取信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'express' => [
                        'sql' => "SELECT * FROM vati_express_record ORDER BY {$sortField} {$sort} LIMIT {$startNum},{$pageDataCount}",
                        'all' => true,
                    ]
                ],
                'trans' => false,
            ]);

            // 判断是否为空
            if (empty($getData['express']['result']))
                throw new Exception("无法取出数据库中第 {$pageNum} 页的数据，因为总共仅有 {$pageCount} 页数据记录");

            // 将数据总条数作为 rows 索引，并且将整个数组赋值给 $result
            $getData['express']['rows'] = $dataCount; $result = $getData['express'];

            // 处理数据
            foreach ($result['result'] as $key => $value)
            {
                // 地址 json 转数组
                $result['result'][$key]['address'] = json_decode($result['result'][$key]['address'], true);

                // 获取账户信息
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'user' => [
                            'sql' => 'SELECT firstname,lastname FROM tblclients WHERE id = ?',
                            'pre' => [$value['userid']],
                        ],
                        'express' => [
                            'sql' => 'SELECT name FROM vati_express WHERE id = ?',
                            'pre' => [$value['express']],
                        ],
                    ],
                    'trans' => false,
                ]);

                $result['result'][$key]['userinfo'] = $getData['user']['result'];
                $result['result'][$key]['expressName'] = $getData['express']['result']['name'];
            }

            // 如果上下页可用，输出页码
            if ($previous) $result['previous'] = $pageNum - 1; if ($next) $result['next'] = $pageNum + 1;

            // 判断是否有 GET 排序规则
            if (isset($_GET['asc'])) $result['asc'] = true;

            // 返回最终整理完成的结果
            return $result;
        }

        // 检查快递是否属于此账户
        public function check($id = '')
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'check' => [
                        'sql' => 'SELECT userid FROM vati_express_record WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['check']['result'])) throw new Exception('数据库中未找到编号为 #'.$id.' 的快递信息');

            if ($getData['check']['result']['userid'] != $this->params->userid) throw new Exception('编号为 #'.$id.' 的快递信息不属于当前账户');
        }

        // 详情
        public function detail($id = '')
        {
            $id = empty($id) ? $_GET['id'] : $id;

            // 判断是否有传递 ID
            if (empty($id)) throw new Exception('当前尚未传递快递信息的编号');

            // 检查是否属于当前账户
            if (!isset($_SESSION['adminid'])) $this->check($id);

            // 查询信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'express' => [
                        'sql' => 'SELECT * FROM vati_express_record WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            // 地址转 json
            $getData['express']['result']['address'] = json_decode($getData['express']['result']['address'], true);

            $result = $getData['express']['result'];

            $getData = $this->params->data->runSQL([
                'action' => [
                    'express' => [
                        'sql' => 'SELECT name,code FROM vati_express WHERE id = ?',
                        'pre' => [$result['express']],
                    ],
                ],
                'trans' => false,
            ]);

            $result['expressName'] = $getData['express']['result']['name'];
            $result['expressCode'] = $getData['express']['result']['code'];

            try
            {
                $result['track'] = $this->track($getData['express']['result']['code'], $result['code']);
//                $result['track'] = $this->track('ZTO', 423301680522);
            }
            catch (Exception $e)
            {
                $result['track'] = $e->getMessage();
            }

            return $result;
        }

        // 搜索
        public function search()
        {
            // 默认 SQL 语句
            $query = "SELECT * FROM vati_express_record WHERE 1 ";

            if (!empty($_POST['express']))
            {
                $query .= "AND express = '{$_POST['express']}' ";
            }

            if (!empty($_POST['name']))
            {
                $query .= "AND name LIKE '%{$_POST['name']}%' ";
            }

            if (!empty($_POST['code']))
            {
                $query .= "AND code LIKE '%{$_POST['code']}%' ";
            }

            if (!empty($_POST['startdate']))
            {
                $query .= "AND timestamp >= '{$_POST['startdate']}' ";
            }

            if (!empty($_POST['orderdate']))
            {
                $query .= "AND timestamp <= '{$_POST['orderdate']}' ";
            }

            // 读取数据库
            $getData = $this->params->data->runSQL([
                'action' => [
                    'search' => [
                        'sql' => $query,
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['search']['result'])) throw new Exception('当前条件下未搜索到相应的记录');

            $result = [
                'result' => $getData['search']['result'],
                'amount' => 0,
            ];

            foreach ($result['result'] as $key => $value)
            {
                // 累加金额
                $result['amount'] = $result['amount'] + $value['amount'];

                // 获取账户信息
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'user' => [
                            'sql' => 'SELECT firstname,lastname FROM tblclients WHERE id = ?',
                            'pre' => [$value['userid']],
                        ],
                    ],
                    'trans' => false,
                ]);

                $result['result'][$key]['userinfo'] = $getData['user']['result'];
            }

            return $result;
        }

        //
    }
}

// 账单
if (!class_exists('invoice'))
{
    class invoice
    {
        private $params;

        public function __construct(array $params = [])
        {
            // 判断是否为空
//            if (empty($params) || empty($params['userid'])) throw new Exception('尚未传递账单信息');

            // 将抬头信息赋值给属性
            $this->params = (object) $params;
        }

        // 取消待审状态
        public function cancel()
        {
            //
            if (!isset($_SESSION['adminid']))
            {
            $this->check($_GET['id']);

            $getData = $this->params->data->runSQL([
                'action' => [
                    'check' => [
                        'sql' => 'SELECT timestamp,status FROM vati_invoice WHERE id = ?',
                        'pre' => [$_GET['id']],
                    ],
                ],
                'trans' => false,
            ]);

            $status = $getData['check']['result']['status'];
            $timestamp = strtotime($getData['check']['result']['timestamp']);

            if ($status != 'warning' || ($timestamp > $timestamp + 1800)) throw new Exception('当前需要取消的发票已超过取消时间(30 分钟)或发票并非待审状态');
            }

            // 删除记录
            $getData = $this->params->data->runSQL([
                'action' => [
                    'cancel' => [
                        'sql' => "UPDATE vati_invoice SET status = 'danger' WHERE id = ?",
                        'pre' => [$_GET['id']],
                    ],
                    'delete' => [
                        'sql' => 'DELETE FROM vati_invoice_record WHERE invoice = ?',
                        'pre' => [$_GET['id']],
                    ],
                ],
            ]);
            
            if ($getData['cancel']['rows'] != 1) throw new Exception('发票取消失败，请稍后重试');
        }

        // 搜索
        public function search()
        {
            // 默认 SQL 语句
            $query = "SELECT * FROM vati_invoice WHERE 1 ";

            if (!empty($_POST['name']))
            {
                $query .= "AND name LIKE '%{$_POST['name']}%' ";
            }

            if (!empty($_POST['invoice']))
            {
                $query .= "AND invoice LIKE '%{$_POST['invoice']}%' ";
            }

            if (!empty($_POST['startdate']))
            {
                $query .= "AND timestamp >= '{$_POST['startdate']}' ";
            }

            if (!empty($_POST['orderdate']))
            {
                $query .= "AND timestamp <= '{$_POST['orderdate']}' ";
            }

            if (!empty($_POST['type']))
            {
                $query .= "AND type = '{$_POST['type']}' ";
            }

            if (!empty($_POST['status']))
            {
                $query .= "AND status = '{$_POST['status']}' ";
            }

            // 读取数据库
            $getData = $this->params->data->runSQL([
                'action' => [
                    'search' => [
                        'sql' => $query,
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['search']['result'])) throw new Exception('当前条件下未搜索到相应的记录');

            $result = [
                'result' => $getData['search']['result'],
                'amount' => 0,
            ];

            foreach ($result['result'] as $key => $value)
            {
                // 累加金额
                $result['amount'] = $result['amount'] + $value['amount'];

                // 获取账户信息
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'user' => [
                            'sql' => 'SELECT firstname,lastname FROM tblclients WHERE id = ?',
                            'pre' => [$value['userid']],
                        ],
                    ],
                    'trans' => false,
                ]);

                $result['result'][$key]['userinfo'] = $getData['user']['result'];
            }

            return $result;
        }

        // 获取支付网关的名字
        public function payment($name = '')
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'payment' => [
                        'sql' => "SELECT value FROM tblpaymentgateways WHERE gateway = ? AND setting = 'name'",
                        'pre' => [$name],
                    ],
                ],
                'trans' => false,
            ]);

            return empty($getData['payment']['result']['value']) ? 'N/A' : $getData['payment']['result']['value'];
        }

        // 检查抬头是否属于此账户
        public function check($id = '')
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'check' => [
                        'sql' => 'SELECT userid FROM vati_invoice WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['check']['result'])) throw new Exception('数据库中未找到编号为 #'.$id.' 的发票信息');

            if ($getData['check']['result']['userid'] != $this->params->userid) throw new Exception('编号为 #'.$id.' 的发票信息不属于当前账户');
        }

        // 列出
        public function get($onlyPaid = true, $userID = '')
        {
            if (!$userID) $userID = $this->params->userid;

            // 默认的查询语句
            $query = 'SELECT id,subtotal,datepaid,paymentmethod FROM tblinvoices WHERE userid = ? AND subtotal > 0';

            // 如果不是仅列出已付
            if ($onlyPaid) $query .= " AND status='Paid'";

            // 读取数据库中关于这个账户已支付并且大于 0 的账单
            $getData = $this->params->data->runSQL([
                'action' => [
                    'invoice' => [
                        'sql' => $query,
                        'pre' => [$userID],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            // 判断是否为空
            if (empty($getData['invoice']['result'])) throw new Exception('当前账户尚未有已消费的账单记录');

            // 用来拼接的空数组
            $invoices = [];

            // 遍历数组
            foreach ($getData['invoice']['result'] as $key => $value)
            {
                try
                {
                    // 检查记录表中是否有当前账单 ID 的记录
                    $getData = $this->params->data->runSQL([
                        'action' => [
                            'record' => [
                                'sql' => 'SELECT invoice FROM vati_invoice_record WHERE id = ?',
                                'pre' => [$value['id']],
                            ],
                        ],
                        'trans' => false,
                    ]);

                    // 如果返回结果不为空则已经存在与队列中、跳出循环继续下一个循环
                    if (!empty($getData['record']['result'])) continue;

                    // 排除充值的账单
                    $getData = $this->params->data->runSQL([
                        'action' => [
                            'check' => [
                                'sql' => "SELECT description FROM tblinvoiceitems WHERE invoiceid = ? AND type != 'AddFunds'",
                                'pre' => [$value['id']],
                                'all' => true,
                            ],
                        ],
                        'trans' => false,
                    ]);

                    // 如果结果不为空说明不是充值账单
                    if (!empty($getData['check']['result']))
                    {
                        // 判断是否存在多个键
                        if (count($getData['check']['result']) > 1)
                        {
                            // 将 description 加入到索引
                            $productName = $getData['check']['result']['0']['description'].', ...';
                        }
                        else
                        {
                            // 将 description 加入到索引
                            $productName = $getData['check']['result']['0']['description'];
                        }

                        // 放入数组返回到模板中
                        $invoices[$key]['id'] = $value['id']; // 账单编号
                        $invoices[$key]['name'] = $productName; // 产品名称
                        $invoices[$key]['date'] = date('Y-m-d', strtotime($value['datepaid'])); // 支付日期
                        $invoices[$key]['amount'] = $value['subtotal']; // 账单总额

                        // 获取付款方式名称
                        $invoices[$key]['payment'] = $this->payment($value['paymentmethod']);
                    }
                }
                catch (Exception $e)
                {
                    // 销毁相应的数组
                    unset($invoices[$key]);

                    // 跳出并继续下一个循环
                    continue;
                }
            }

            // 判断最后出来的结果中是否有账单
            if (empty($invoices)) throw new Exception('未搜寻到可用的账单，可能是由于当前账户所涉及的账单均为充值账单');

            return $invoices;
        }

        // 列出所有账单
        public function getAllRecord()
        {
            // 默认开启上下页
            $previous = true; $next = true;

            // 获取开票表的行数
            $getData = $this->params->data->runSQL([
                'action' => [
                    'count' => [
                        'sql' => 'SELECT count(*) FROM vati_invoice',
                    ],
                    'page' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'dataCount'",
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['count']['result'])) throw new Exception('数据库中没有已开票记录');

            // 数据记录总条数
            $dataCount = current($getData['count']['result']);

            // 页面数据条数
            $pageDataCount = $getData['page']['result']['value'];

            // 计算总页数，以 . 分割为数组、以便下方检测是否小数
            $pageCount = $dataCount / $pageDataCount; $pageCountArray = explode('.', $pageCount);

            // 判断是否小数，如果是小数的话加一页(例如: 16 条数据，以 5 条为一页、那么有 4 页数据)
            if (isset($pageCountArray['1'])) $pageCount = $pageCountArray['0'] + 1;

            // 当前页码
            $pageNum = empty($_GET['pagenum']) ? 1 : (int) $_GET['pagenum'];

            // 如果总页数小于每页条数，那么就隐藏上下页
            if ($dataCount <= $pageDataCount)
            {
                $previous = false; $next = false;
            }
            else if ($pageNum + 1 > $pageCount)
            {
                $next = false;
            }
            else if ($pageNum - 1 < 1)
            {
                $previous = false;
            }

            // 获取取出数据的起点，并且判断是否指定正序输出(默认倒序)
            $startNum = ($pageNum - 1) * $pageDataCount; $sort = isset($_GET['asc']) ? 'ASC' : 'DESC';

            // 正则匹配纯英文字母的 field 并且赋值给变量
            preg_match('/[a-zA-Z]+/', empty($_GET['orderby']) ? 'id' : (string) htmlentities($_GET['orderby']), $matches);

            // 将正则匹配出的纯字符赋值给变量，此时获取到的 field 已经是纯字母、避免下面 SQL 注入的问题
            $sortField = $matches['0']; if (empty($sortField)) throw new Exception('排序字段仅允许传递纯字母');

            // 获取信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'invoice' => [
                        'sql' => "SELECT * FROM vati_invoice ORDER BY {$sortField} {$sort} LIMIT {$startNum},{$pageDataCount}",
                        'all' => true,
                    ]
                ],
                'trans' => false,
            ]);

            // 判断是否为空
            if (empty($getData['invoice']['result']))
                throw new Exception("无法取出数据库中第 {$pageNum} 页的数据，因为总共仅有 {$pageCount} 页数据记录");

            // 将数据总条数作为 rows 索引，并且将整个数组赋值给 $result
            $getData['invoice']['rows'] = $dataCount; $result = $getData['invoice'];

            // 处理数据
            foreach ($result['result'] as $key => $value)
            {
                // 地址 json 转数组
                $result['result'][$key]['address'] = json_decode($result['result'][$key]['address'], true);

                // 获取账户信息
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'user' => [
                            'sql' => 'SELECT firstname,lastname FROM tblclients WHERE id = ?',
                            'pre' => [$value['userid']],
                        ],
                    ],
                    'trans' => false,
                ]);

                $result['result'][$key]['userinfo'] = $getData['user']['result'];
            }

            // 如果上下页可用，输出页码
            if ($previous) $result['previous'] = $pageNum - 1; if ($next) $result['next'] = $pageNum + 1;

            // 判断是否有 GET 排序规则
            if (isset($_GET['asc'])) $result['asc'] = true;

            // 返回最终整理完成的结果
            return $result;
        }

        // 选择信息
        public function selectInfo()
        {
            // 默认账单金额
            $amount = 0;

            // 累加账单金额
            foreach ($_POST['invoice'] as $value)
            {
                // 查询账单金额并且检查账单
                $checkInvoice = $this->checkInvoice($value);

                $amount = $amount + $checkInvoice;
            }

            // 返回金额与账单
            return [
                'amount' => $amount,
                'invoice' => $_POST['invoice'],
            ];
        }

        // 新增发票
        public function newInvoice()
        {
            // 判断是否为空
            if (empty($_POST['invoice'])) throw new Exception('当前尚未传递账单信息，请重新开票');

            // 赋值
            $_POST['invoice'] = explode(',', $_POST['invoice']);

            $amount = 0;
            $invoice = [];
            foreach ($_POST['invoice'] as $value)
            {
                if (empty($value)) continue;

                // 检查账单并计算金额
                $amount = $amount + $this->checkInvoice($value);

                $invoice[] = $value;
            }

            // 添加发票
            $this->insert([
                'type' => $_POST['title']['type'],
                'name' => $_POST['title']['name'],
                'address' => json_encode($_POST['address']),
                'amount' => $amount,
                'invoice' => $invoice,
            ]);
        }

        // 管理员新增发票
        public function newAdminInvoice()
        {
            $params = [
                'userid' => '用户编号',
                'titleid' => '抬头编号',
                'addressid' => '地址编号',
                'invoiceid' => '账单编号',
                'invoiceNumber' => '开票编号',
            ];

            foreach ($params as $key => $value)
            {
                if (empty($_POST[$key])) throw new Exception('当前尚未选择或输入 '.$value.' 信息，请重新开票');
            }

            // 赋值
            $userid = $_POST['userid']; $title = $_POST['titleid']; $address = $_POST['addressid'];
            $_POST['invoiceid']  = explode(',', $_POST['invoiceid']); $invoiceNum = $_POST['invoiceNumber'];

            // 查询抬头和地址信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'title' => [
                        'sql' => 'SELECT type,name FROM vati_title WHERE id = ?',
                        'pre' => [$title],
                    ],
                    'address' => [
                        'sql' => 'SELECT * FROM vati_address WHERE id = ?',
                        'pre' => [$address],
                    ],
                ],
                'trans' => false,
            ]);

            // 赋值
            $title = $getData['title']['result'];
            $address = json_encode($getData['address']['result']);

            $amount = 0;
            $invoice = [];
            foreach ($_POST['invoiceid'] as $value)
            {
                if (empty($value)) continue;

                $getData = $this->params->data->runSQL([
                    'action' => [
                        'check' => [
                            'sql' => "SELECT amount FROM tblinvoiceitems WHERE invoiceid = ? AND type != 'AddFunds'",
                            'pre' => [$value],
                        ],
                    ],
                    'trans' => false,
                ]);

                // 检查账单并计算金额
                $amount = $amount + $getData['check']['result']['amount'];

                $invoice[] = $value;
            }

            // 获取下一个自增 ID
            $getData = $this->params->data->runSQL([
                'action' => [
                    'id' => [
                        'sql' => "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_NAME = 'vati_invoice'",
                    ],
                ],
                'trans' => false,
            ]);

            $nextID = $getData['id']['result']['AUTO_INCREMENT'];

            // 写入数据
            $getData = $this->params->data->runSQL([
                'action' => [
                    'insert' => [
                        'sql' => "INSERT INTO vati_invoice (userid, type, name, invoice, address, amount, status) VALUES (?,?,?,?,?,?,'success')",
                        'pre' => [$userid, $title['type'],  $title['name'], $invoiceNum, $address, $amount],
                    ],
                ],
            ]);

            // 判断是否成功
            if ($getData['insert']['rows'] != 1) throw new Exception('开票失败，请返回重试操作');

            // 写入账单记录
            $query = [];
            foreach ($invoice as $value)
            {
                $query[$value] = [
                    'sql' => 'INSERT INTO vati_invoice_record (id, invoice) VALUES (?,?)',
                    'pre' => [$value, $nextID],
                ];
            }

            // 写入账单记录
            $this->params->data->runSQL([
                'action' => $query,
            ]);
        }

        // 检查账单编号
        public function checkInvoice($invoiceID = '')
        {
            // 查询账单金额并且检查账单
            $getData = $this->params->data->runSQL([
                'action' => [
                    'invoice' => [
                        'sql' => "SELECT userid,amount FROM tblinvoiceitems WHERE invoiceid = ? AND type != 'AddFunds'",
                        'pre' => [$invoiceID],
                    ],
                    'paid' => [
                        'sql' => 'SELECT status FROM tblinvoices WHERE id = ?',
                        'pre' => [$invoiceID],
                    ],
                    'record' => [
                        'sql' => 'SELECT invoice FROM vati_invoice_record WHERE id = ?',
                        'pre' => [$invoiceID],
                    ],
                ],
                'trans' => false,
            ]);

            // 判断是否有记录
            if (empty($getData['invoice']['result'])) throw new Exception('在系统中不存在账单编号 #'.$invoiceID);

            // 判断 userid
            if ($this->params->userid != $getData['invoice']['result']['userid']) throw new Exception('当前所传递的账单编号 #'.$invoiceID.' 不属于当前账户');

            // 判断账单是否已付款
            if ($getData['paid']['result']['status'] != 'Paid') throw new Exception('当前所传递的账单编号 #'.$invoiceID.' 尚未付款，请完成付款操作后再进行申请');

            // 判断是否已存在于记录中
            if (!empty($getData['record']['result'])) throw new Exception('账单编号 #'.$invoiceID.' 已经存在于开票记录中，请返回重新选择');

            // 返回金额
            return $getData['invoice']['result']['amount'];
        }

        // 获取开票记录
        public function getRecord()
        {
            // 获取数据库
            $getData = $this->params->data->runSQL([
                'action' => [
                    'record' => [
                        'sql' => 'SELECT * FROM vati_invoice WHERE userid = ?',
                        'pre' => [$this->params->userid],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            // 判断是否为空
            if (empty($getData['record']['result'])) throw new Exception('当前账户下没有已开票的记录');

            // 返回结果
            return $getData['record']['result'];
        }

        // 后台修改抬头
        public function changeInvoice()
        {
            // 判断是否缺少值
            $params = [
                'status' => '状态',
                'id' => '抬头编号',
            ];

            foreach ($params as $key => $value)
            {
                if (empty($_POST[$key])) throw new Exception('当前尚未传递 '.$value.' 的值，请返回重试');
            }

            // 修改开票信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'update' => [
                        'sql' => 'UPDATE vati_invoice SET status = ? , invoice = ? WHERE id = ?',
                        'pre' => [$_POST['status'], empty($_POST['invoice']) ? '' : $_POST['invoice'], $_POST['id']],
                    ],
                ],
            ]);

            if ($getData['update']['rows'] != 1) throw new Exception('发票信息修改失败');
        }

        // 插入开票记录
        public function insert(array $invoice = [])
        {
            // 获取下一个自增 ID
            $getData = $this->params->data->runSQL([
                'action' => [
                    'id' => [
                        'sql' => "SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_NAME = 'vati_invoice'",
                    ],
                ],
                'trans' => false,
            ]);

            $nextID = $getData['id']['result']['AUTO_INCREMENT'];

            // 写入数据
            $getData = $this->params->data->runSQL([
                'action' => [
                    'insert' => [
                        'sql' => "INSERT INTO vati_invoice (userid, type, name, invoice, address, amount, status) VALUES (?,?,?,?,?,?,'warning')",
                        'pre' => [$this->params->userid, $invoice['type'],  $invoice['name'], '', $invoice['address'], $invoice['amount']],
                    ],
                ],
            ]);

            // 判断是否成功
            if ($getData['insert']['rows'] != 1) throw new Exception('开票失败，请返回重试操作');

            // 写入账单记录
            $query = [];
            foreach ($invoice['invoice'] as $value)
            {
                $query[$value] = [
                    'sql' => 'INSERT INTO vati_invoice_record (id, invoice) VALUES (?,?)',
                    'pre' => [$value, $nextID],
                ];
            }

            // 写入账单记录
            $this->params->data->runSQL([
                'action' => $query,
            ]);
        }

        // 更新记录
        public function update()
        {
            //
            $params = [
                'id' => '发票记录编号',
//                'invoice' => '发票号',
                'status' => '发票状态',
            ];

            foreach ($params as $key => $value)
            {
                //
                if (empty($_POST[$key])) throw new Exception('当前尚未传递 '.$value.' 因此无法修改当前发票的状态');
            }

            if ($_POST['status'] == 'success' && empty($_POST['invoice'])) throw new Exception('如果需要修改为开票状态、请填写发票号');

            $getData = $this->params->data->runSQL([
                'action' => [
                    'update' => [
                        'sql' => 'UPDATE vati_invoice SET invoice = ? , status = ? WHERE id = ?',
                        'pre' => [$_POST['status'] == 'success' ? $_POST['invoice'] : '', $_POST['status'], $_POST['id']],
                    ],
                ],
            ]);

            if ($getData['update']['rows'] != 1) throw new Exception('发票信息修改失败');
        }

        // 详情
        public function detail($id = '')
        {
            $id = empty($id) ? $_GET['id'] : $id;

            // 判断是否有传递 ID
            if (empty($id)) throw new Exception('当前尚未传递发票信息的编号');

            // 检查是否属于当前账户
            if (!isset($_SESSION['adminid'])) $this->check($id);

            // 查询信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'invoice' => [
                        'sql' => 'SELECT * FROM vati_invoice WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            $result = $getData['invoice']['result'];

            // 处理地址
            $result['address'] = json_decode($result['address'], true);

            // 查找关联账单
            $getData = $this->params->data->runSQL([
                'action' => [
                    'invoice' => [
                        'sql' => 'SELECT id FROM vati_invoice_record WHERE invoice = ?',
                        'pre' => [$id],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            $result['invoices'] = empty($getData['invoice']['result']) ? false : $getData['invoice']['result'];

            if ($result['invoices'])
            {
                foreach ($result['invoices'] as $key => $value)
                {
                    // 查询账单金额
                    $getData = $this->params->data->runSQL([
                        'action' => [
                            'invoice' => [
                                'sql' => 'SELECT datepaid,subtotal,paymentmethod FROM tblinvoices WHERE id = ?',
                                'pre' => [$value['id']],
                            ],
                        ],
                        'trans' => false,
                    ]);

                    $result['invoices'][$key]['payment'] = $this->payment($getData['invoice']['result']['paymentmethod']);
                    $result['invoices'][$key]['amount'] = $getData['invoice']['result']['subtotal']; // 账单总额
                    $result['invoices'][$key]['date'] = date('Y-m-d', strtotime($getData['invoice']['result']['datepaid'])); // 支付日期

                    $getData = $this->params->data->runSQL([
                        'action' => [
                            'invoice' => [
                                'sql' => 'SELECT description FROM tblinvoiceitems WHERE invoiceid = ?',
                                'pre' => [$value['id']],
                            ],
                        ],
                        'trans' => false,
                    ]);

                    // 判断是否存在多个键
                    if (count($getData['invoice']['result']) > 1)
                    {
                        // 将 description 加入到索引
                        $productName = $getData['invoice']['result']['description'].', ...';
                    }
                    else
                    {
                        // 将 description 加入到索引
                        $productName = $getData['invoice']['result']['description'];
                    }

                    // 放入数组返回到模板中
                    $result['invoices'][$key]['name'] = $productName; // 产品名称
                }
            }

            // 查找快递记录
            try
            {
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'express' => [
                            'sql' => 'SELECT express,code FROM vati_express_record WHERE invoice = ?',
                            'pre' => [$id],
                        ],
                    ],
                    'trans' => false,
                ]);

                if (empty($getData['express']['result'])) throw new Exception('当前发票尚未发快递，请等候管理员发送快递');

                $code = $getData['express']['result']['code'];

                // 查询快递的代码
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'express' => [
                            'sql' => 'SELECT code FROM vati_express WHERE id = ?',
                            'pre' => [$getData['express']['result']['express']],
                        ],
                    ],
                    'trans' => false,
                ]);

                // 实例化类
                $invoiceManager = new invoiceManager();

                $result['track'] = $invoiceManager->express()->track($getData['express']['result']['code'], $code);
//                $result['track'] = $this->track('ZTO', 423301680522);
            }
            catch (Exception $e)
            {
                $result['track'] = $e->getMessage();
            }

            return $result;
        }

        //
    }
}

// 抬头
if (!class_exists('title'))
{
    class title
    {
        private $params;

        public function __construct(array $params = [])
        {
            // 判断是否为空
//            if (empty($params) || empty($params['userid'])) throw new Exception('尚未传递抬头信息');

            // 将抬头信息赋值给属性
            $this->params = (object) $params;
        }

        public function fileSize()
        {
            // 读取文件大小
            $getData = $this->params->data->runSQL([
                'action' => [
                    'size' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'fileSize'",
                    ],
                ],
            ]);

            // 判断是否为空
            if (empty($getData['size']['result'])) return 512; // 如果为空默认限制 512 KB
            else return $getData['size']['result']['value']; // 如果不为空、fileSize 等于设置的内容
        }

        // 修改参数
        public function changeParams(array $params = [])
        {
            // 判断是否为空
            if (empty($params)) throw new Exception('传入参数为空，因此无法修改抬头类的属性');

            // 加入数据库和扩展类
            $params['data'] = $this->params->data; $params['extend'] = $this->params->extend;

            // 赋值为属性
            $this->params = $params;
        }

        // 文件后缀
        public function extsName()
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'exts' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'extsName'",
                    ],
                ],
                'trans' => false,
            ]);

            return $getData['exts']['result']['value'];
        }

        // 更新或写入抬头信息
        public function change()
        {
            // 判断是否有传递抬头类型
            if (empty($_POST['titletype'])) throw new Exception('当前尚未传递抬头类型');

            // 默认的抬头信息
            $titleName = '个人';
            $invoiceType = 'standard';

            // 默认的 info 输入框信息
            $info_1 = ''; $info_2 = ''; $info_3 = ''; $info_4 = ''; $info_5 = '';

            // 判断抬头类型是否企业
            if ($_POST['titletype'] == 'enterprise')
            {
                // 判断发票抬头是否已填写
                if (empty($_POST['invoicetitle'])) throw new Exception('当前尚未填写公司发票抬头');

                // 企业的抬头信息
                $titleName = $_POST['invoicetitle'];

                // 判断是否有填写税务登记号
                if (empty($_POST['info_1'])) throw new Exception('当前未填写税务登记证号');

                $info_1 = $_POST['info_1'];

                // 判断发票类型
                if ($_POST['invoicetype'] == 'special')
                {
                    $invoiceType = $_POST['invoicetype'];

                    // info_1 ~ 5 的名字
                    $info = [
                        'info_2' => '基本开户银行名称',
                        'info_3' => '基本开户账号',
                        'info_4' => '注册场所地址',
                        'info_5' => '注册固定电话',
                    ];

                    // 检查填空框是否有填写
                    foreach ($info as $key => $value)
                    {
                        if (empty($_POST[$key])) throw new Exception('当前尚未填写'.$value.'，请返回重新设置');
                    }

                    // 企业所输入的信息
                    $info_2 = $_POST['info_2']; $info_3 = $_POST['info_3']; $info_4 = $_POST['info_4']; $info_5 = $_POST['info_5'];

                    // file_1 ~ 3 的名字
                    $file = [
                        'file_1' => '营业执照',
                        'file_3' => '一般纳税人资格证',
                    ];

                    // 检查文件是否上传
                    foreach ($file as $key => $value)
                    {
                        if (empty($_FILES[$key])) throw new Exception('您未上传'.$value.'，请返回重新设置');
                    }

                    // 检查 attachments 目录是否可写
                    if (!is_readable($GLOBALS['attachments_dir']) || !is_writeable($GLOBALS['attachments_dir']))
                        throw new Exception("请检查目录 [ {$GLOBALS['attachments_dir']} ] 是否具备读写权限");

                    // 允许上传的文件类型
                    $exts = explode(' ', $this->extsName());

                    // 用来保存文件的标识
                    $fileName = md5(time().$this->params->userid);

                    // 上传的文件名
                    $file = [];

                    // 循环 _FILES 处理上传过来的文件
                    foreach ($_FILES as $key => $value)
                    {
                        // 以 . 分割为数组、获取文件的后缀
                        $extsName = explode('.', $value['name']); $extsName = end($extsName);

                        // 判断文件是否允许上传
                        if ($key != 'file_2' && !in_array($extsName, $exts))
                            throw new Exception('上传的图片非 '.$this->extsName().' 图片文件，请返回重新上传');

                        // 查阅是否有错误、如果有的话报错
                        if ($key != 'file_2' && !empty($value['error'])) throw new Exception('上传文件时出现错误，错误信息: '.$value['error']);

                        // 移动文件到目录
                        move_uploaded_file($value['tmp_name'], $GLOBALS['attachments_dir'].'/'.$fileName.'_'.$key.'.'.$extsName);

                        if ($key == 'file_2' && !empty($value['error'])) $file['file_2'] = '';
                        else $file[$key] = $fileName.'_'.$key.'.'.$extsName;
                    }

                    $fileName = '';

                    // 处理文件名
                    foreach ($file as $value)
                    {
                        //
                        $fileName .= $value.'|';
                    }

                    $fileName = substr($fileName, 0, -1);

                    //
                }
            }

            // 判断是否有包含 ID
            if (!empty($_POST['id']))
            {
                $this->check($_POST['id']);

                $action = 'update';
            }
            else
            {
                $action = 'insert';
            }

            // 操作
            $this->$action([
                'name' => $titleName,
                'type' => $invoiceType,
                'info_1' => $info_1,
                'info_2' => $info_2,
                'info_3' => $info_3,
                'info_4' => $info_4,
                'info_5' => $info_5,
                'file' => empty($fileName) ? '' : $fileName,
                'id' => empty($_POST['id']) ? '' : $_POST['id'],
            ]);
        }

        // 检查账户是否有设置抬头
        public function count()
        {
            //
            $getData = $this->params->data->runSQL([
                'action' => [
                    'count' => [
                        'sql' => 'SELECT count(*) FROM vati_title WHERE userid = ?',
                        'pre' => [$this->params->userid],
                    ],
                ],
                'trans' => false,
            ]);

            return empty($getData['count']['result']) ? 0 : current($getData['count']['result']);
        }

        // 检查抬头是否属于此账户
        public function check($id = '')
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'check' => [
                        'sql' => 'SELECT userid,status FROM vati_title WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['check']['result'])) throw new Exception('数据库中未找到编号为 #'.$id.' 的抬头信息');

            if ($getData['check']['result']['userid'] != $this->params->userid) throw new Exception('编号为 #'.$id.' 的抬头信息不属于当前账户');

//            if ($getData['check']['result']['status'] != 'danger') throw new Exception('编号为 #'.$id.' 的抬头信息并非驳回状态，因此不允许修改');
        }

        // 列出
        public function get($onlySuccess = false)
        {
            $query = 'SELECT * FROM vati_title WHERE userid = ?';

            if ($onlySuccess) $query .= " AND status = 'success'";

            $getData = $this->params->data->runSQL([
                'action' => [
                    'title' => [
                        'sql' => $query,
                        'pre' => [$this->params->userid],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['title']['result'])) throw new Exception('当前账户下尚无可用的抬头信息');

            return $getData['title']['result'];
        }

        // 列出所有抬头
        public function getAll()
        {
            // 默认开启上下页
            $previous = true; $next = true;

            $getData = $this->params->data->runSQL([
                'action' => [
                    'count' => [
                        'sql' => 'SELECT count(*) FROM vati_title',
                    ],
                    'page' => [
                        'sql' => "SELECT value FROM tbladdonmodules WHERE module = 'invoiceManager' AND setting = 'dataCount'",
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['count']['result'])) throw new Exception('数据库中没有抬头记录');

            // 数据记录总条数
            $dataCount = current($getData['count']['result']);

            // 页面数据条数
            $pageDataCount = $getData['page']['result']['value'];

            // 计算总页数，以 . 分割为数组、以便下方检测是否小数
            $pageCount = $dataCount / $pageDataCount; $pageCountArray = explode('.', $pageCount);

            // 判断是否小数，如果是小数的话加一页(例如: 16 条数据，以 5 条为一页、那么有 4 页数据)
            if (isset($pageCountArray['1'])) $pageCount = $pageCountArray['0'] + 1;

            // 当前页码
            $pageNum = empty($_GET['pagenum']) ? 1 : (int) $_GET['pagenum'];

            // 如果总页数小于每页条数，那么就隐藏上下页
            if ($dataCount <= $pageDataCount)
            {
                $previous = false; $next = false;
            }
            else if ($pageNum + 1 > $pageCount)
            {
                $next = false;
            }
            else if ($pageNum - 1 < 1)
            {
                $previous = false;
            }

            // 获取取出数据的起点，并且判断是否指定正序输出(默认倒序)
            $startNum = ($pageNum - 1) * $pageDataCount; $sort = isset($_GET['asc']) ? 'ASC' : 'DESC';

            // 正则匹配纯英文字母的 field 并且赋值给变量
            preg_match('/[a-zA-Z]+/', empty($_GET['orderby']) ? 'id' : (string) htmlentities($_GET['orderby']), $matches);

            // 将正则匹配出的纯字符赋值给变量，此时获取到的 field 已经是纯字母、避免下面 SQL 注入的问题
            $sortField = $matches['0']; if (empty($sortField)) throw new Exception('排序字段仅允许传递纯字母');

            // 获取信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'title' => [
                        'sql' => "SELECT * FROM vati_title ORDER BY {$sortField} {$sort} LIMIT {$startNum},{$pageDataCount}",
                        'all' => true,
                    ]
                ],
                'trans' => false,
            ]);

            // 判断是否为空
            if (empty($getData['title']['result']))
                throw new Exception("无法取出数据库中第 {$pageNum} 页的数据，因为总共仅有 {$pageCount} 页数据记录");

            // 将数据总条数作为 rows 索引，并且将整个数组赋值给 $result
            $getData['title']['rows'] = $dataCount; $result = $getData['title'];

            // 处理数据
            foreach ($result['result'] as $key => $value)
            {
                // 获取账户信息
                $getData = $this->params->data->runSQL([
                    'action' => [
                        'user' => [
                            'sql' => 'SELECT firstname,lastname FROM tblclients WHERE id = ?',
                            'pre' => [$value['userid']],
                        ],
                    ],
                    'trans' => false,
                ]);

                $result['result'][$key]['userinfo'] = $getData['user']['result'];
            }

            // 如果上下页可用，输出页码
            if ($previous) $result['previous'] = $pageNum - 1; if ($next) $result['next'] = $pageNum + 1;

            // 判断是否有 GET 排序规则
            if (isset($_GET['asc'])) $result['asc'] = true;

            // 返回最终整理完成的结果
            return $result;
        }

        // 后台修改抬头
        public function changeTitle()
        {
            // 判断是否缺少值
            $params = [
                'status' => '状态',
                'id' => '抬头编号',
            ];

            foreach ($params as $key => $value)
            {
                if (empty($_POST[$key])) throw new Exception('当前尚未传递 '.$value.' 的值，请返回重试');
            }

            // 修改抬头信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'update' => [
                        'sql' => 'UPDATE vati_title SET status = ? , remark = ? WHERE id = ?',
                        'pre' => [$_POST['status'], empty($_POST['remark']) ? '' : $_POST['remark'], $_POST['id']],
                    ],
                ],
            ]);

            if ($getData['update']['rows'] != 1) throw new Exception('抬头信息修改失败');
        }

        // 插入
        public function insert(array $title = [])
        {
            // 查看抬头数量是否大于等于 5
            if ($this->count() >= 5) throw new Exception('当前账户可添加的抬头数量已满，因此无法继续添加');

            // 查看是否已包含此抬头
            $getData = $this->params->data->runSQL([
                'action' => [
                    'check' => [
                        'sql' => 'SELECT id FROM vati_title WHERE userid = ? AND name = ?',
                        'pre' => [$this->params->userid, $title['name']],
                    ],
                ],
                'trans' => false,
            ]);

            if (!empty($getData['check']['result'])) throw new Exception('当前账户已设置过名为 '.$title['name'].' 的抬头信息');

            // 判断状态
            if (empty($title['status']))
            {
                if ($title['type'] == 'standard')
                    $status = 'success';
                else
                {
                    $status = 'warning';
                }
            }
            else
            {
                $status = $title['status'];
            }

            $getData = $this->params->data->runSQL([
                'action' => [
                    'insert' => [
                        'sql' => 'INSERT INTO vati_title (userid, name, type, info_1, info_2, info_3, info_4, info_5, file, remark, status) VALUES (?,?,?,?,?,?,?,?,?,?,?)',
                        'pre' => [$this->params->userid, $title['name'], $title['type'], $title['info_1'], $title['info_2'], $title['info_3'], $title['info_4'], $title['info_5'], $title['file'], empty($title['remark']) ? '' : $title['remark'], $status],
                    ],
                ],
            ]);

            if ($getData['insert']['rows'] != 1) throw new Exception('抬头信息添加失败');
        }

        // 更新
        public function update(array $title = [])
        {
            // 检查是否驳回状态
            $getData = $this->params->data->runSQL([
                'action' => [
                    'check' => [
                        'sql' => 'SELECT status FROM vati_title WHERE id = ?',
                        'pre' => [$title['id']],
                    ],
                ],
                'trans' => false,
            ]);

            if ($getData['check']['result']['status'] != 'danger') throw new Exception('当前所编辑的抬头信息已通过审核，因此不可修改');

            // 判断状态
            if (empty($title['status']))
            {
                if ($title['type'] == 'standard')
                    $status = 'success';
                else
                {
                    $status = 'warning';
                }
            }
            else
            {
                $status = $title['status'];
            }

            $getData = $this->params->data->runSQL([
                'action' => [
                    'update' => [
                        'sql' => 'UPDATE vati_title SET name = ? , type = ? , info_1 = ? , info_2 = ? , info_3 = ? , info_4 = ? , info_5 = ? , file = ? , remark = ? , status = ? WHERE id = ?',
                        'pre' => [$title['name'], $title['type'], $title['info_1'], $title['info_2'], $title['info_3'], $title['info_4'], $title['info_5'], $title['file'], empty($title['remark']) ? '' : $title['remark'], $status, $title['id']],
                    ],
                ],
            ]);

            if ($getData['update']['rows'] != 1) throw new Exception('抬头信息更新失败');
        }

        // 详情
        public function detail($id = '')
        {
            $id = empty($id) ? $_GET['id'] : $id;

            // 判断是否有传递 ID
            if (empty($id)) throw new Exception('当前尚未传递抬头信息的编号');

            // 检查是否属于当前账户
            if (!isset($_SESSION['adminid'])) $this->check($id);

            // 查询信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'title' => [
                        'sql' => 'SELECT * FROM vati_title WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            $fileName = explode('|', $getData['title']['result']['file']);

            $getData['title']['result']['file_1'] = $fileName['0'];
            $getData['title']['result']['file_2'] = $fileName['1'];
            $getData['title']['result']['file_3'] = $fileName['2'];

            return $getData['title']['result'];
        }

        // 删除抬头
        public function delete()
        {
            // 检查是否属于当前账户
            if (!isset($_SESSION['adminid'])) $this->check($_GET['id']);

            $getData = $this->params->data->runSQL([
                'action' => [
                    'delete' => [
                        'sql' => 'DELETE FROM vati_title WHERE id = ?',
                        'pre' => [$_GET['id']],
                    ],
                ],
            ]);

            if ($getData['delete']['rows'] != 1) throw new Exception('抬头信息删除失败');
        }

        //
    }
}

// 地址
if (!class_exists('address'))
{
    class address
    {
        private $params;

        public function __construct(array $params = [])
        {
            // 判断是否为空
            if (empty($params) || empty($params['userid'])) throw new Exception('尚未传递地址信息');

            // 将抬头信息赋值给属性
            $this->params = (object) $params;
        }

        // 修改属性
        public function change()
        {
            // 地址表单的值与中文名
            $address = [
                'name' => '收件人名',
                'mobile' => '手机号码',
//                'phone' => '联系电话',
                's_province' => '省份',
//                's_city' => '地级市',
//                's_county' => '市、县级市',
                'address' => '详细地址',
            ];

            foreach ($address as $key => $value)
            {
                if (empty($_POST[$key])) throw new Exception('当前未填写 '.$value.' 的值，请重新设置');
            }

            // 默认值
            $name = $_POST['name']; $mobile = empty($_POST['mobile']) ? '' : $_POST['mobile']; $phone = $_POST['phone'];
            $s_province = $_POST['s_province']; $s_city = empty($_POST['s_city']) ? '' : $_POST['s_city']; $s_county = empty($_POST['s_county']) ? '' : $_POST['s_county']; $address = $_POST['address'];

            // 判断是否有包含 ID
            if (!empty($_POST['id']))
            {
                $this->check($_POST['id']);

                $action = 'update';
            }
            else
            {
                $action = 'insert';
            }

            // 操作
            $this->$action([
                'name' => $name,
                'mobile' => $mobile,
                'phone' => $phone,
                'province' => $s_province,
                'address' => $s_city.$s_county.$address,
                'id' => empty($_POST['id']) ? '' : $_POST['id'],
            ]);
        }

        // 检查账户是否有设置地址
        public function count()
        {
            //
            $getData = $this->params->data->runSQL([
                'action' => [
                    'count' => [
                        'sql' => 'SELECT count(*) FROM vati_address WHERE userid = ?',
                        'pre' => [$this->params->userid],
                    ],
                ],
                'trans' => false,
            ]);

            return empty($getData['count']['result']) ? 0 : current($getData['count']['result']);
        }

        // 查询地址是否存在
        public function check($id = '')
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'check' => [
                        'sql' => 'SELECT userid FROM vati_address WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['check']['result'])) throw new Exception('在数据库中未找到地址编号为 #'.$this->params->id.' 的记录');

            if ($getData['check']['result']['userid'] != $this->params->userid) throw new Exception('地址编号为 #'.$this->params->id.' 的记录不属于当前账户');
        }

        // 列出
        public function get()
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'address' => [
                        'sql' => 'SELECT * FROM vati_address WHERE userid = ?',
                        'pre' => [$this->params->userid],
                        'all' => true,
                    ],
                ],
                'trans' => false,
            ]);

            if (empty($getData['address']['result'])) throw new Exception('当前账户下尚未设置地址信息');

            return $getData['address']['result'];
        }

        // 插入
        public function insert(array $address = [])
        {
            $getData = $this->params->data->runSQL([
                'action' => [
                    'insert' => [
                        'sql' => 'INSERT INTO vati_address (userid, name, province, address, mobile, phone) VALUES (?,?,?,?,?,?)',
                        'pre' => [$this->params->userid, $address['name'], $address['province'], $address['address'], $address['mobile'], $address['phone']],
                    ],
                ],
            ]);

            if ($getData['insert']['rows'] != 1) throw new Exception('地址信息添加失败');
        }

        // 更新
        public function update(array $address = [])
        {
            // 检查是否属于当前账户
            $this->check($address['id']);

            $getData = $this->params->data->runSQL([
                'action' => [
                    'update' => [
                        'sql' => 'UPDATE vati_address SET name = ? , province = ? , address = ? , mobile = ? , phone = ? WHERE id = ?',
                        'pre' => [$address['name'], $address['province'], $address['address'], $address['mobile'], $address['phone'], $address['id']],
                    ],
                ],
            ]);

            if ($getData['update']['rows'] != 1) throw new Exception('地址信息更新失败');
        }

        // 删除
        public function delete()
        {
            // 检查是否属于当前账户
            $this->check($_GET['id']);

            $getData = $this->params->data->runSQL([
                'action' => [
                    'delete' => [
                        'sql' => 'DELETE FROM vati_address WHERE id = ?',
                        'pre' => [$_GET['id']],
                    ],
                ],
            ]);

            if ($getData['delete']['rows'] != 1) throw new Exception('地址信息删除失败');
        }

        // 详情
        public function detail($id = '')
        {
            $id = empty($id) ? $_GET['id'] : $id;

            // 判断是否有传递 ID
            if (empty($id)) throw new Exception('当前尚未传递地址信息的编号');

            // 检查是否属于当前账户
            $this->check($id);

            // 查询信息
            $getData = $this->params->data->runSQL([
                'action' => [
                    'address' => [
                        'sql' => 'SELECT * FROM vati_address WHERE id = ?',
                        'pre' => [$id],
                    ],
                ],
                'trans' => false,
            ]);

            return $getData['address']['result'];
        }

        //
    }
}