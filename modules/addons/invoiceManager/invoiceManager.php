<?php
!defined('WHMCS') AND die('Access denied.');

// 引入通用类
require_once ROOTDIR.'/modules/addons/NeWorld/library/class/NeWorld.Common.Class.php';

function invoiceManager_activate()
{
    try
    {
        // 检查 attachments 目录是否可写
        if (!is_readable($GLOBALS['attachments_dir']) || !is_writeable($GLOBALS['attachments_dir']))
            throw new Exception("请检查目录 [ {$GLOBALS['attachments_dir']} ] 是否具备读写权限");

        // 实例化数据库类
        $db = new NeWorld\Database();

        // 检查数据库是否存在
        if (
            $db->checkTable('vati_title') ||
            $db->checkTable('vati_invoice') ||
            $db->checkTable('vati_address') ||
            $db->checkTable('vati_express') ||
            $db->checkTable('vati_express_price') ||
            $db->checkTable('vati_express_record') ||
            $db->checkTable('vati_invoice_record')
        ) throw new Exception('当前数据库中已存在 Invoice Manager 相关的数据表，请检查数据库是否清洁');

        // 导入数据库
        $db->putSQL([
            'dir' => __DIR__.'/data',
            'sql' => 'activate',
        ]);

        // 检查数据库是否存在
        if (
            !$db->checkTable('vati_title') ||
            !$db->checkTable('vati_invoice') ||
            !$db->checkTable('vati_address') ||
            !$db->checkTable('vati_express') ||
            !$db->checkTable('vati_express_price') ||
            !$db->checkTable('vati_express_record') ||
            !$db->checkTable('vati_invoice_record')
        ) throw new Exception('数据库操作失败，所需要的表无法导入，请登录 phpMyAdmin 检查数据库操作权限是否正常');

        // 返回信息
        $result = [
            'status' => 'success',
            'description' => '模块已成功激活，请单击 [ Configure ] 按钮、勾选 [ Full Administrator ] 后保存即可访问控制台',
        ];
    }
    catch (Exception $e)
    {
        // 返回信息
        $result = [
            'status' => 'error',
            'description' => $e->getMessage(),
        ];
    }
    finally
    {
        return $result;
    }
}

function invoiceManager_deactivate()
{
    try
    {
        // 实例化数据库类
        $db = new NeWorld\Database();

        // 检查数据库是否存在
        if (
            !$db->checkTable('vati_title') ||
            !$db->checkTable('vati_invoice') ||
            !$db->checkTable('vati_address') ||
            !$db->checkTable('vati_express') ||
            !$db->checkTable('vati_express_price') ||
            !$db->checkTable('vati_express_record') ||
            !$db->checkTable('vati_invoice_record')
        ) throw new Exception('数据库操作失败，所需要的表有缺少，请登录 phpMyAdmin 检查数据库是否包含 7 个 vati_ 开头的数据表');

        // 删除数据库
        $db->deleteTable(['vati_title', 'vati_invoice', 'vati_address', 'vati_express', 'vati_express_price', 'vati_express_record', 'vati_invoice_record']);

        // 检查数据库是否存在
        if (
            $db->checkTable('vati_title') ||
            $db->checkTable('vati_invoice') ||
            $db->checkTable('vati_address') ||
            $db->checkTable('vati_express') ||
            $db->checkTable('vati_express_price') ||
            $db->checkTable('vati_express_record') ||
            $db->checkTable('vati_invoice_record')
        ) throw new Exception('数据库中仍然存在相应的表，请登录 phpMyAdmin 检查数据库操作权限是否正常');

        // 返回信息
        $result = [
            'status' => 'success',
            'description' => '模块已成功关闭，现在你可以安全删除 Invoice Manager 相关文件',
        ];
    }
    catch (Exception $e)
    {
        // 返回信息
        $result = [
            'status' => 'error',
            'description' => $e->getMessage(),
        ];
    }
    finally
    {
        return $result;
    }
}

function invoiceManager_config()
{
    return [
        'name' => 'Invoice Manager',
        'description' => '基于 WHMCS & NeWorld Manager 的发票、快递开具模块',
        'version' => '1.0',
        'author' => '<a target="_blank" href="https://neworld.org/">NeWorld</a>',
        'fields' => [
            'dataCount' => [
                'Type' => 'text',
                'Default' => '10',
                'FriendlyName' => '数据条数',
                'Description' => '设置每页所显示的数据条数',
            ],
            'fileSize' => [
                'Type' => 'text',
                'Default' => '512',
                'FriendlyName' => '图片限制',
                'Description' => '设置用户上传图片的大小限制，单位: KB',
            ],
            'companyName' => [
                'Type' => 'text',
                'Default' => '某某公司',
                'FriendlyName' => '公司名称',
                'Description' => '请填写你用于发快递的公司名称',
            ],
            'expressName' => [
                'Type' => 'text',
                'Default' => '某人',
                'FriendlyName' => '发件人名',
                'Description' => '请填写用于发件信息的人名',
            ],
            'expressAddress' => [
                'Type' => 'text',
                'Default' => '某某地址',
                'FriendlyName' => '发件地址',
                'Description' => '请填写用于发件的地址信息',
            ],
            'expressPhone' => [
                'Type' => 'text',
                'Default' => '123456',
                'FriendlyName' => '发件电话',
                'Description' => '请填写用于发件的联系电话',
            ],
            'extsName' => [
                'Type' => 'text',
                'Default' => 'jpg jpeg gif png bmp',
                'FriendlyName' => '图片后缀',
                'Description' => '允许上传的图片后缀',
            ],
        ],
    ];
}

function invoiceManager_output()
{
    try
    {
        // 实例化发票管理器类
        $invoiceManager = new NeWorld\InvoiceManager();

        try
        {
            // 判断页面
            switch ($_GET['page'])
            {
                case 'get':
                    try
                    {
                        $result = [
                            'status' => 'success',
                            'result' => $invoiceManager->common()->userInfo(),
                        ];

                        try
                        {
                            // 加入发票
                            $result['result']['invoice'] = $invoiceManager->invoice()->get(false, $_GET['id']);
                        }
                        catch (Exception $e)
                        {
                            //
                        }
                    }
                    catch (Exception $e)
                    {
                        $result = [
                            'status' => 'error',
                            'info' => $e->getMessage(),
                        ];
                    }
                    finally
                    {
                        die(json_encode($result));
                    }
                    break;
                case 'amount':
                    try
                    {
                        if (empty($_GET['express']) || empty($_GET['province'])) throw new Exception('当前尚未传递快递或省市信息');

                        $result = [
                            'status' => 'success',
                            'result' => $invoiceManager->common()->sumAmount(),
                        ];
                    }
                    catch (Exception $e)
                    {
                        $result = [
                            'status' => 'error',
                            'info' => $e->getMessage(),
                        ];
                    }
                    finally
                    {
                        die(json_encode($result));
                    }
                    break;
                case 'invoice':
                    switch ($_GET['action'])
                    {
                        case 'detail':
                            if (empty($_GET['id'])) throw new Exception('当前尚未传递需要查看详情的开票记录 ID 编号');

                            // 读取抬头列表
                            $result = [
                                'pageName' => 'invoice.detail',
                                'invoice' => false,
                            ];

                            try
                            {
                                if (!empty($_POST))
                                {
                                    // 处理开票
                                    $invoiceManager->invoice()->update();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '开票状态更新成功');
                                }
                            }
                            catch (Exception $e)
                            {
                                $result['notice'] .= $invoiceManager->common()->tips('danger', '发票开具失败，错误信息: '.$e->getMessage());
                            }

                            $result['invoice'] = $invoiceManager->invoice()->detail($_GET['id']);
                            break;
                        default:
                            // 开票页面
                            $result = [
                                'pageName' => 'invoice',
                                'notice' => '',
                            ];

                            try
                            {
                                if (!empty($_POST))
                                {
                                    // 处理开票
                                    $invoiceManager->invoice()->newAdminInvoice();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '发票开具成功');
                                }

                                if ($_GET['action'] == 'cancel')
                                {
	                                // teNsi0n 2016-12-31 增加返回列表页
				                    $result = [
				                        'pageName' => 'default',
				                        'notice' => '',
				                    ];
				                    
                                    try
                                    {
                                        if (empty($_GET['id'])) throw new Exception('如果需要作废已提交申请的发票、请传递 ID 编号');

                                        // 取消待审的发票
                                        $invoiceManager->invoice()->cancel();
					                    
                                        // 返回成功提示
                                        $result['notice'] .= $invoiceManager->common()->tips('success', '发票申请已作废成功');
                                        // 获取发票
										$result['invoice'] = $invoiceManager->invoice()->getAllRecord();
                                    }
                                    catch (Exception $e)
                                    {
                                        $result['notice'] .= $invoiceManager->common()->tips('danger', $e->getMessage());
                                    }
                                }
                            }
                            catch (Exception $e)
                            {
                                $result['notice'] .= $invoiceManager->common()->tips('danger', '发票开具失败，错误信息: '.$e->getMessage());
                            }
                    }
                    break;
                case 'title':
                    switch ($_GET['action'])
                    {
                        case 'detail':
                        	if ( $_GET['img'] ) {
	                        	// 设置图片路径
								$filename 	= $GLOBALS['attachments_dir'] . '/' . $_GET['img'];
								$size 		= getimagesize($filename); //获取mime信息 
								$fp			= fopen($filename, "rb"); //二进制方式打开文件 
								if ( $size && $fp ) { 
									header("Content-type: {$size['mime']}"); 
									fpassthru($fp); // 输出至浏览器 
									exit;
                        		}
                        	}
                            if (empty($_GET['id'])) throw new Exception('当前尚未传递需要查看详情的抬头记录 ID 编号');

                            // 读取抬头列表
                            $result = [
                                'pageName' => 'title.detail',
                                'title' => $invoiceManager->title()->detail($_GET['id']),
                            ];
                            break;
                        default:
                            // 读取抬头列表
                            $result = [
                                'pageName' => 'title',
                                'notice' => '',
                                'title' => false,
                            ];

                            try
                            {
                                if (!empty($_POST))
                                {
                                    try
                                    {
                                        // 修改抬头信息
                                        $invoiceManager->title()->changeTitle();

                                        $result['notice'] .= $invoiceManager->common()->tips('success', '抬头信息修改成功');
                                    }
                                    catch (Exception $e)
                                    {
                                        $result['notice'] .= $invoiceManager->common()->tips('danger', '抬头信息修改失败，错误信息: '.$e->getMessage());
                                    }
                                }

                                // 获取发票
                                $result['title'] = $invoiceManager->title()->getAll();
                            }
                            catch (Exception $e)
                            {
                                $result['message'] = $e->getMessage();
                            }
                    }
                    break;
                case 'express':
                    switch ($_GET['action'])
                    {
                        case 'detail':
                            if (empty($_GET['id'])) throw new Exception('当前尚未传递需要查看详情的快递记录 ID 编号');

                            // 读取快递信息
                            $result = [
                                'pageName' => 'express.detail',
                                'express' => $invoiceManager->express()->detail($_GET['id']),
                                'setting' => $invoiceManager->express()->getExpressSetting(),
                            ];
                            break;
                        case 'list':
                            // 读取发票列表
                            $result = [
                                'pageName' => 'express.list',
                                'notice' => '',
                                'express' => false,
                            ];

                            try
                            {
                                if (!empty($_POST))
                                {
                                    try
                                    {
                                        // 处理快递信息
                                        $invoiceManager->express()->update();

                                        $result['notice'] .= $invoiceManager->common()->tips('success', '快递信息更新成功');
                                    }
                                    catch (Exception $e)
                                    {
                                        $result['notice'] .= $invoiceManager->common()->tips('danger', '快递信息更新成功，错误信息: '.$e->getMessage());
                                    }
                                }

                                // 获取发票
                                $result['express'] = $invoiceManager->express()->getAll();
                            }
                            catch (Exception $e)
                            {
                                $result['message'] = $e->getMessage();
                            }
                            break;
                        case 'print':
                            if (empty($_GET['id'])) throw new Exception('当前尚未传递快递的 ID 编号');

                            try
                            {
                                $result['info'] = $invoiceManager->express()->detail($_GET['id']);
                                $result['send'] = $invoiceManager->express()->sendInfo();
                            }
                            catch (Exception $e)
                            {
                                $result['info'] = false;
                            }

                            // 输出模板
                            die($invoiceManager->template([
                                'file' => 'admin/express.print',
                                'vars' => $result,
                            ]));
                            break;
                        default:
                            // 开票页面
                            $result = [
                                'pageName' => 'express',
                                'notice' => '',
                                'express' => false,
                            ];

                            try
                            {
                                if (!empty($_POST))
                                {
                                    // 处理开票
                                    $express = $invoiceManager->express()->newExpress();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '快递新增成功，单击 "<a href="addonmodules.php?module=invoiceManager&page=express&action=print&id='.$express.'" target="_blank">此处</a>" 立即打印快递单');
                                }
                            }
                            catch (Exception $e)
                            {
                                $result['notice'] .= $invoiceManager->common()->tips('danger', '快递新增失败，错误信息: '.$e->getMessage());
                            }

                            // 返回快递信息
                            $result['express'] = $invoiceManager->express()->getExpressSetting();

                            // 返回已开票但是无快递的信息
                            $result['invoices'] = $invoiceManager->express()->getExpressInvoice();
                    }
                    break;
                case 'express_manager':
                    switch ($_GET['action'])
                    {
                        case 'price':
                            $result = [
                                'pageName' => 'express.price',
                                'notice' => '',
                                'price' => false,
                            ];

                            if (empty($_GET['id'])) throw new Exception('如果需要修改快递区域价格，请传递快递 ID 编号');

                            if (!empty($_GET['delete']))
                            {
                                try
                                {
                                    $invoiceManager->express()->deletePrice();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '区域快递价格删除成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', '区域快递价格删除失败，错误信息: '.$e->getMessage());
                                }
                            }

                            if (!empty($_POST))
                            {
                                try
                                {
                                    // 修改快递设置
                                    $invoiceManager->express()->changeExpressPrice();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '快递区域价格设置保存成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', '快递区域价格设置修改失败，错误信息: '.$e->getMessage());
                                }
                            }

                            $result['id'] = $_GET['id'];
                            $result['price'] = $invoiceManager->express()->getExpressPrice();
                            break;
                        default:
                            // 读取快递列表
                            $result = [
                                'pageName' => 'express.manager',
                                'notice' => '',
                                'express' => false,
                            ];

                            if ($_GET['action'] == 'delete')
                            {

                                try
                                {
                                    if (empty($_GET['id'])) throw new Exception('如果需要删除快递设置，请务必传递 ID 编号');

                                    $invoiceManager->express()->delete();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '快递信息删除成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', '快递信息删除失败，错误信息: '.$e->getMessage());
                                }
                            }

                            if (!empty($_POST))
                            {
                                try
                                {
                                    // 修改快递设置
                                    $invoiceManager->express()->changeExpress();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '快递信息保存成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', '快递信息修改失败，错误信息: '.$e->getMessage());
                                }
                            }

                            // 获取发票
                            $result['express'] = $invoiceManager->express()->getExpressSetting();
                    }
                    break;
                case 'invoice_search':
                    $result = [
                        'pageName' => 'invoice.search',
                        'notice' => '',
                        'result' => false,
                    ];

                    if (!empty($_POST))
                    {
                        try
                        {
                            $result['result'] = $invoiceManager->invoice()->search();
                        }
                        catch (Exception $e)
                        {
                            $result['notice'] = $invoiceManager->common()->tips('danger', '搜索失败，错误信息: '.$e->getMessage());
                        }

                        $result['post'] = $_POST;
                    }
                    break;
                case 'express_search':
                    $result = [
                        'pageName' => 'express.search',
                        'notice' => '',
                        'result' => false,
                    ];

                    if (!empty($_POST))
                    {
                        try
                        {
                            $result['result'] = $invoiceManager->express()->search();
                        }
                        catch (Exception $e)
                        {
                            $result['notice'] = $invoiceManager->common()->tips('danger', '搜索失败，错误信息: '.$e->getMessage());
                        }

                        $result['post'] = $_POST;
                    }

                    // 返回快递信息
                    $result['express'] = $invoiceManager->express()->getExpressSetting();
                    break;
                default:
                    // 读取发票列表
                    $result = [
                        'pageName' => 'default',
                        'notice' => '',
                        'invoice' => false,
                    ];

                    try
                    {

                        // 获取发票
                        $result['invoice'] = $invoiceManager->invoice()->getAllRecord();
                    }
                    catch (Exception $e)
                    {
                        $result['message'] = $e->getMessage();
                    }
            }
        }
        catch (Exception $e)
        {
            $result = [
                'pageName' => 'error',
                'message' => $e->getMessage(),
            ];
        }

        // 模块地址
        $result['modulelinks'] = 'addonmodules.php?module=invoiceManager';

        $result['attachments_dir'] = explode(ROOTDIR, $GLOBALS['attachments_dir'])['1'];

        // 输出模板
        $result = $invoiceManager->template([
            'file' => 'admin/home',
            'vars' => $result,
        ]);
    }
    catch (Exception $e)
    {
        $result = '无法启动 Invoice Manager 模块，错误信息: '.$e->getMessage();
    }
    finally
    {
        echo $result;
    }
}

function invoiceManager_clientarea()
{
    try
    {
        // 实例化扩展类
//        $ext = new Extended();

        // 实例化发票管理器类
        $invoiceManager = new NeWorld\InvoiceManager();

        // 判断页面
        switch ($_GET['page'])
        {
            case 'invoice':
                switch ($_GET['action'])
                {
                    case 'detail':
                        try
                        {
                            $result = [
                                'pageName' => 'invoice.detail',
                                'detail' => $invoiceManager->invoice()->detail(),
                            ];
                        }
                        catch (Exception $e)
                        {
                            $result = [
                                'pageName' => 'error',
                                'message' => $e->getMessage(),
                            ];
                        }
                        break;
                    case 'info':
                        try
                        {
                            $result = [
                                'pageName' => 'invoice.info',
                            ];

                            // 判断是否有传递信息
                            if (empty($_POST['invoice'])) throw new Exception('请由申请开票页面选择相应的账单后访问此页面');

                            // 返回新增页面所需要的详情
                            $result['info'] = $invoiceManager->invoice()->selectInfo();

                            // 返回地址和抬头
                            $result['title'] = $invoiceManager->title()->get(true);
                            $result['address'] = $invoiceManager->address()->get();
                        }
                        catch (Exception $e)
                        {
                            $result = [
                                'pageName' => 'error',
                                'message' => $e->getMessage(),
                            ];
                        }
                        break;
                    default:
                        $result = [
                            'pageName' => 'invoice',
                            'notice' => '',
                            'invoice' => false,
                        ];

                        try
                        {
                            // 判断是否有 GET
                            if ($_GET['action'] == 'new')
                            {
                                try
                                {
                                    // 判断是否有 POST
                                    if (empty($_POST)) throw new Exception('若需要新增发票，请在申请开票页面选择相应的账单按步骤添加');

                                    // 赋值地址和抬头
                                    $_POST['title'] = $invoiceManager->title()->detail($_POST['title']);
                                    $_POST['address'] = $invoiceManager->address()->detail($_POST['address']);

                                    // 处理新增开票
                                    $invoiceManager->invoice()->newInvoice();

                                    // 返回成功提示
                                    $result['notice'] .= $invoiceManager->common()->tips('success', '抬头名称为 '.$_POST['title']['name'].' 的发票已申请成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', $e->getMessage());
                                }
                            }
                            elseif ($_GET['action'] == 'cancel')
                            {
                                try
                                {
                                    if (empty($_GET['id'])) throw new Exception('如果需要取消当前申请的发票、请传递 ID 编号');

                                    // 取消待审的发票
                                    $invoiceManager->invoice()->cancel();

                                    // 返回成功提示
                                    $result['notice'] .= $invoiceManager->common()->tips('success', '发票申请已取消成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', $e->getMessage());
                                }
                            }

                            // 获取发票信息
                            $result['invoice'] = $invoiceManager->invoice()->getRecord();
                        }
                        catch (Exception $e)
                        {
                            $result['message'] = $e->getMessage();
                        }
                }
                break;
            case 'express':
                switch ($_GET['action'])
                {
                    case 'detail':
                        try
                        {
                            $result = [
                                'pageName' => 'express.detail',
                                'detail' => $invoiceManager->express()->detail(),
                            ];
                        }
                        catch (Exception $e)
                        {
                            $result = [
                                'pageName' => 'error',
                                'message' => $e->getMessage(),
                            ];
                        }
                        break;
                    default:
                        //
                        $result = [
                            'pageName' => 'express',
                            'notice' => '',
                            'express' => false,
                        ];
                        try
                        {
                            // 获取快递
                            $result['express'] = $invoiceManager->express()->getRecord();
                        }
                        catch (Exception $e)
                        {
                            $result['message'] = $e->getMessage();
                        }
                }
                break;
            case 'title':
                switch ($_GET['action'])
                {
                    case 'detail':
                    	if ( $_GET['img'] ) {
                        	// 设置图片路径
							$filename 	= $GLOBALS['attachments_dir'] . '/' . $_GET['img'];
							$size 		= getimagesize($filename); //获取mime信息 
							$fp			= fopen($filename, "rb"); //二进制方式打开文件 
							if ( $size && $fp ) { 
								header("Content-type: {$size['mime']}"); 
								fpassthru($fp); // 输出至浏览器 
								exit;
                    		}
                    	}
                        try
                        {
                            $result = [
                                'pageName' => 'title.detail',
                                'detail' => $invoiceManager->title()->detail(),
                            ];
                        }
                        catch (Exception $e)
                        {
                            $result = [
                                'pageName' => 'error',
                                'message' => $e->getMessage(),
                            ];
                        }
                        break;
                    case 'editor':
                        try
                        {
                            $result = [
                                'pageName' => 'title.editor',
                                'fileSize' => $invoiceManager->title()->fileSize(),
                                'extsName' => $invoiceManager->title()->extsName(),
                            ];

                            // 如果有传递 ID、则说明是修改某 ID
                            if (!empty($_GET['id']))
                            {
                                // 检查抬头编号
                                $invoiceManager->title()->check($_GET['id']);

                                // 返回详情
                                $result['detail'] = $invoiceManager->title()->detail();

                                // 将 ID 传递到模板
                                $result['id'] = $_GET['id'];
                            }
                        }
                        catch (Exception $e)
                        {
                            $result = [
                                'pageName' => 'error',
                                'message' => $e->getMessage(),
                            ];
                        }
                        break;
                    default:
                        $result = [
                            'pageName' => 'title',
                            'notice' => '',
                            'title' => false,
                        ];

                        try
                        {
                            if ($_GET['action'] == 'delete')
                            {
                                try
                                {
                                    if (empty($_GET['id'])) throw new Exception('如果需要删除抬头信息，请传递相应的 ID 编号');

                                    // 删除抬头
                                    $invoiceManager->title()->delete();

                                    $result['notice'] .= $invoiceManager->common()->tips('success', '抬头删除成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', $e->getMessage());
                                }
                            }
                            if (!empty($_POST))
                            {
                                try
                                {
                                    // 处理 POST 过来的信息
                                    $invoiceManager->title()->change();

                                    // 返回成功信息
                                    $result['notice'] .= $invoiceManager->common()->tips('success', '名称为 '.(empty($_POST['invoicetitle']) ? '个人' : $_POST['invoicetitle']).' 的抬头信息'.(empty($_POST['id']) ? '添加' : '更新').'成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', $e->getMessage());
                                }
                            }

                            // 获取抬头
                            $result['count'] = $invoiceManager->title()->count();

                            // 获取抬头信息
                            $result['title'] = $invoiceManager->title()->get();
                        }
                        catch (Exception $e)
                        {
                            $result['message'] = $e->getMessage();
                        }
                }
                break;
            case 'address':
                switch ($_GET['action'])
                {
                    case 'detail':
                        try
                        {
                            $result = [
                                'pageName' => 'address.detail',
                                'detail' => $invoiceManager->address()->detail(),
                            ];
                        }
                        catch (Exception $e)
                        {
                            $result = [
                                'pageName' => 'error',
                                'message' => $e->getMessage(),
                            ];
                        }
                        break;
                    case 'editor':
                        try
                        {
                            $result = [
                                'pageName' => 'address.editor',
                            ];

                            // 如果有传递 ID、则说明是修改某 ID
                            if (!empty($_GET['id']))
                            {
                                // 检查抬头编号
                                $invoiceManager->address()->check($_GET['id']);

                                // 返回详情
                                $result['detail'] = $invoiceManager->address()->detail();

                                // 将 ID 传递到模板
                                $result['id'] = $_GET['id'];
                            }
                        }
                        catch (Exception $e)
                        {
                            $result = [
                                'pageName' => 'error',
                                'message' => $e->getMessage(),
                            ];
                        }
                        break;
                    default:
                        $result = [
                            'pageName' => 'address',
                            'notice' => '',
                            'address' => false,
                        ];

                        try
                        {
                            if ($_GET['action'] == 'delete')
                            {
                                // 判断是否有传递 id
                                if (empty($_GET['id'])) $result['notice'] .= $invoiceManager->common()->tips('danger', '如果需要删除地址，请传递相应的 ID 编号');

                                // 删除地址
                                $invoiceManager->address()->delete();

                                $result['notice'] .= $invoiceManager->common()->tips('success', '相应的地址信息删除成功');
                            }
                            if (!empty($_POST))
                            {
                                try
                                {
                                    // 处理 POST 过来的信息
                                    $invoiceManager->address()->change();

                                    // 返回成功信息
                                    $result['notice'] .= $invoiceManager->common()->tips('success', '收件人名称为 '.$_POST['name'].' 的地址信息'.(empty($_POST['id']) ? '添加' : '更新').'成功');
                                }
                                catch (Exception $e)
                                {
                                    $result['notice'] .= $invoiceManager->common()->tips('danger', $e->getMessage());
                                }
                            }

                            // 获取地址信息
                            $result['address'] = $invoiceManager->address()->get();
                        }
                        catch (Exception $e)
                        {
                            $result['message'] = $e->getMessage();
                        }
                }
                break;
            default:
                try
                {
                    $result = [
                        'pageName' => 'default',
                        'notice' => '',
                        'title' => true,
                        'address' => true,
                        'invoices' => false,
                    ];

                    // 查询账户抬头的条数
                    if ($invoiceManager->title()->count() <= 0)
                    {
                        $result['title'] = false;
                        $result['notice'] .= $invoiceManager->common()->tips('danger', '当前账户尚未设置抬头信息，<a class="btn btn-default btn-xs" href="index.php?m=invoiceManager&page=title&action=editor">立即设置</a>');
                    }

                    // 查询账户地址的条数
                    if ($invoiceManager->address()->count() <= 0)
                    {
                        $result['address'] = false;
                        $result['notice'] .= $invoiceManager->common()->tips('danger', '当前账户尚未设置地址信息，<a class="btn btn-default btn-xs" href="index.php?m=invoiceManager&page=address&action=editor">立即设置</a>');
                    }

                    // 获取账单列表
                    $result['invoices'] = $invoiceManager->invoice()->get();
                }
                catch (Exception $e)
                {
                    $result['message'] = $e->getMessage();
                }
        }

        //
    }
    catch (Exception $e)
    {
        // 返回报错结果
        $result = [
            'pageName' => 'tips/danger',
            'message' => $e->getMessage(),
        ];
    }
    finally
    {
        $result['attachments_dir'] = explode(ROOTDIR, $GLOBALS['attachments_dir'])['1'];

        // 返回模板
        return [
			'pagetitle'    => '发票管理',
            'requirelogin' => true,
            'templatefile' => 'templates/client/home',
            'breadcrumb' => [
                'index.php?m=invoiceManager' => '发票管理'
            ],
            'vars' => $result,
        ];
    }
}