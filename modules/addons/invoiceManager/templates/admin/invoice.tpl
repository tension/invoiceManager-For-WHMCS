<style>
    .none-data {
        margin: 50px 0;
    }
    .no-data-info .fa {
        color: #D32E1D;
        font-weight: 400;
        vertical-align: middle;
    }
</style>
<script type="text/javascript" src="/assets/js/selectize.js"></script>
<link rel="stylesheet" type="text/css" href="/assets/css/selectize.bootstrap3.css" />
<script type="text/javascript" src="/assets/js/AdminClientDropdown.js"></script>
<script type="text/javascript">

    function getClientSearchPostUrl() {
        return './ordersadd.php';
    }

    function CheckAll(obj){
        $("input[type='checkbox']").prop('checked', $(obj).prop('checked'));
        clickinvoice();
    }

    function clickinvoice() {
        var sum=0;
        var count=0;
        var id='';
        var checked = $("input[name='invoice[]']:checkbox:checked");
        checked.each(function(){
            id += $(this).data('id')+',';
            sum= parseFloat($(this).data('price'));
            if(sum != NaN && $.trim(sum) != "" && sum != null && !isNaN(sum))
                count += sum;
        });
        $("#invoiceid").val(id);
        $(".total .number").text(Number(count).toFixed(2));
        $("#amount").val(Number(count).toFixed(2));
    }

    function checkValue()
    {
        var titleid = $('[name="titleid"]').val();
        var invoiceid = $('[name="invoiceid"]').val();
        var addressid = $('[name="addressid"]').val();
        var invoiceNumber = $('[name="invoiceNumber"]').val();

        // 判断是否为空
        if (titleid.length == 0) {
	        sweetAlert({ title: "错误", text: "你尚未勾选抬头信息", type: "error", confirmButtonText: "确定" });
	    } else if (addressid.length == 0) {
		    sweetAlert({ title: "错误", text: "你尚未勾选地址", type: "error", confirmButtonText: "确定" });
		} else if (invoiceid.length == 0) {
	        sweetAlert({ title: "错误", text: "你尚未勾选账单信息", type: "error", confirmButtonText: "确定" });
	    } else if (invoiceNumber.length == 0) {
		    sweetAlert({ title: "错误", text: "你尚未输入发票号", type: "error", confirmButtonText: "确定" });
	    } else {
            // 提交表单
            $('#addForm').submit();
        }
    }

    $(function(){

        $('.selectize').selectize();

        // 选择用户后触发
        $('#selectUserid').change(function(){

            var userID = $(this).val();
            if ( userID != '' ) {

                $('#title').text('');
                $('#invoicetype').text('');
                $('#detail').hide();
                $('#info_1').text('');
                $('#info_2').text('');
                $('#info_3').text('');
                $('#info_4').text('');
                $('#info_5').text('');
                $('#name').text('');
                $('#phone').text('');
                $('#addrs').text('');

                $.ajax({ //调用jquery的ajax方法
                    type: 'get', //设置ajax方法提交数据的形式
                    url: '{$modulelinks}&page=get&id=', //把数据提交
                    data: { "id" : userID }, //输入框Writer中的值作为提交的数据
                    dataType: 'json',
                    beforeSend:function(XMLHttpRequest){
                        $('.loadingDiv').fadeIn();
                    },
                    success: function(data) { //提交成功后的回调。
                        if (data.status == 'success') {
                            $('#userid').val(userID);

                            $('.addInvoice-info').html('');
                            $('.addInvoice-addr').html('');
                            $('#tableInvoicePlusList tbody').html('');
                            // 正常
                            var title       	= data.result.title;
                            var invoice 		= data.result.invoice;
                            var address 		= data.result.address;

                            if ( title ) {
                                var titlehtml = '';
                                $.each(title, function (n, val) {
                                    var type = '增值税专用发票';

                                    if (val.type == 'standard') {
                                        type = '增值税普通发票';
                                    }

                                    titlehtml += '<div class="col-sm-6" data-id="'+val.id+'" data-title="'+val.name+'" data-type="'+type+'" data-info_1="'+val.info_1+'" data-info_2="'+val.info_2+'" data-info_3="'+val.info_3+'" data-info_4="'+val.info_4+'" data-info_5="'+val.info_5+'">';
                                    titlehtml += '<div class="radio-main">';
                                    titlehtml += '<strong style="display: block;">'+val.name+'</strong>';
                                    titlehtml += '<span>'+type+'</span>';
                                    titlehtml += '</div>';
                                    titlehtml += '</div>';
                                });
                                $('.addInvoice-info').append(titlehtml);

                                $(".addInvoice-info > div").click(function () {
                                    $(this).addClass("selected");
                                    $(this).siblings().removeClass("selected");

                                    // 侧边栏写入数据
                                    $('#title').text($(this).data('title'));
                                    $('#invoicetype').text($(this).data('type'));
                                    if ( $(this).data('title') != "个人" ) {
	                                    $('#tax').show();
                                        $('#info_1').text($(this).data('info_1'));
                                    }
                                    if ( $(this).data('type') != "增值税普通发票" ) {
	                                    $('#tax').show();
                                        $('#detail').show();
                                        $('#info_2').text($(this).data('info_2'));
                                        $('#info_3').text($(this).data('info_3'));
                                        $('#info_4').text($(this).data('info_4'));
                                        $('#info_5').text($(this).data('info_5'));
                                    } else {
                                        $('#detail').hide();
                                    }
                                    $('#titleid').val($(this).data('id'));
                                });
                            } else {
                                $('.addInvoice-info .none-data').hide();
                                $('.addInvoice-info').append('<div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何抬头信息</a></div></div>');
                            }

                            if ( address ) {
                                var addhtml = '';
                                $.each(address, function (n, val) {
                                    addhtml += '<div class="col-sm-6" data-name="'+val.name+'" data-id="'+val.id+'" data-mobile="'+val.mobile+'" data-tel="' + val.phone + '" data-addr="' + val.province + val.address + '">';
                                    addhtml += '<div class="radio-main"><dl><dt>';
                                    addhtml += '<em class="uname">'+val.name+'</em>';
                                    addhtml += '</dt><dd class="utel">';
                                    addhtml += val.mobile;
                                    addhtml += '</dd><dd class="uaddress">';
                                    addhtml += val.province + val.address;
                                    addhtml += '</dd></dl></div></div>';
                                });
                                $('.addInvoice-addr').append(addhtml);

                                $(".addInvoice-addr > div").click(function () {
                                    $(this).addClass("selected");
                                    $(this).siblings().removeClass("selected");
                                    // 侧边栏写入数据
                                    $('#name').text($(this).data('name'));
                                    $('#phone').text($(this).data('mobile'));
                                    $('#addrs').text($(this).data('addr'));

                                    $('#addressid').val($(this).data('id'));
                                });
                            } else {

                                $('.addInvoice-addr .none-data').hide();
                                $('.addInvoice-addr').append('<div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何地址信息</a></div></div>');
                            }

                            if ( invoice ) {
                                var invoicehtml = '';
                                $.each(invoice, function (n, val) {
                                    invoicehtml += '<tr class="odd" role="row">';
                                    invoicehtml += '<td class="text-center"><input type="checkbox" name="invoice[]" value="'+val.id+'" data-id="'+val.id+'" data-price="'+val.amount+'"></td>';
                                    invoicehtml += '<td>'+val.id+'</td>';
                                    invoicehtml += '<td>'+val.name+'</td>';
                                    invoicehtml += '<td class="price">'+val.amount+'</td>';
                                    invoicehtml += '<td>'+val.payment+'</td>';
                                    invoicehtml += '<td class="sorting_1">'+val.date+'</td>';
                                    invoicehtml += '</tr>';
                                });

                                $('#tableList .none-data').hide();
                                $('#tableList tbody').append(invoicehtml);

                                $("input[name='invoice[]']:checkbox").click(function () {
                                    clickinvoice();
                                });
                            } else {

                                $('#tableList .none-data').hide();
                                $('#tableList').append('<div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何账单</a></div></div>');
                            }

                        } else {
                            // 错误
                            alert(data.info);
                        }
                        $('.loadingDiv').fadeOut();
                    },
                    error: function(data) {
                        $('.loadingDiv').fadeOut();
                    }
                });
            }
        });
    });

</script>

{$notice}

<div class="row client-dropdown-container">
    <div class="col-md-5 col-sm-9">
        <select id="selectUserid" name="userid" class="form-control selectize-client-search" placeholder="输入查询的客户名或ID、邮箱" data-value-field="id" tabindex="-1">
            <option value=""></option>
        </select>
    </div>
</div>
<div class="row detail">
    <div class="col-sm-8 addInvoice admin">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    抬头信息
                    <span class="loadingDiv" style="display: none;">
							<i class="fa fa-spinner fa-pulse fa-fw"></i>
						</span>
                </h3>
            </div>
            <div class="panel-body">
                <div class="row addInvoice-info">
                    <div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何抬头信息</a></div></div>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    地址信息
                    <span class="loadingDiv" style="display: none;">
							<i class="fa fa-spinner fa-pulse fa-fw"></i>
						</span>
                </h3>
            </div>
            <div class="panel-body">
                <div class="row addInvoice-addr">
                    <div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何地址信息</a></div></div>
                </div>
            </div>
        </div>
        <!-- Panel End -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">账单信息</h3>
            </div>
            <div class="panel-body" style="padding: 0;" id="tableList">
                <table id="tableInvoicePlusList" class="table table-list dataTable no-footer dtr-inline" role="grid">
                    <thead>
                    <tr role="row">
                        <th width="10" class="text-center"><input type="checkbox" onclick="CheckAll(this)" /></th>
                        <th>账单编号</th>
                        <th>产品名称</th>
                        <th>消费金额</th>
                        <th>支付方式</th>
                        <th>支付日期</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
                <div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何抬头信息</a></div></div>
            </div>
        </div>
        <!-- Panel End -->
    </div>
    <div class="col-sm-4">
        <div class="panel panel-primary invoices-info">
            <div class="panel-heading">
                <h4 class="panel-title">开票信息</h4>
            </div>
            <div class="panel-body">
                <p>
                    <label>发票抬头：</label>
                    <span id="title"></span>
                </p>
                <p>
                    <label>发票类型：</label>
                    <span id="invoicetype"></span>
                </p>
                <div id="tax" style="display: none">
                    <p>
                        <label>纳税人识别号：</label>
                        <span id="info_1"></span>
                    </p>
                </div>
                <div id="detail" style="display: none">
                    <hr/>
                    <p>
                        <label>基本户银行名称：</label>
                        <span id="info_2"></span>
                    </p>
                    <p>
                        <label>基本户账号：</label>
                        <span id="info_3"></span>
                    </p>
                    <p>
                        <label>注册场所地址：</label>
                        <span id="info_4"></span>
                    </p>
                    <p>
                        <label>注册固定电话：</label>
                        <span id="info_5"></span>
                    </p>
                </div>
                <hr/>
                <p class="total">
                    <label>开票金额：</label>
                    <span class="number">0.00</span>
                </p>
            </div>
        </div>
        <form action="{$modulelinks}&page=invoice" method="POST" id="addForm">
            <input type="hidden" name="userid" value="" id="userid" />
            <input type="hidden" name="titleid" value="" id="titleid" />
            <input type="hidden" name="addressid" value="" id="addressid" />
            <input type="hidden" name="invoiceid" value="" id="invoiceid" />
            <div class="panel panel-primary invoices-info">
                <div class="panel-heading">
                    <h4 class="panel-title">其他信息</h4>
                </div>
                <div class="panel-body">
                    <p>
                        <label>发票号：</label>
                        <input type="text" name="invoiceNumber" class="form-control" placeholder="请输入发票号" />
                    </p>
                </div>
            </div>
            <button type="button" class="btn btn-primary btn-block" onclick="checkValue();">确认开票</button>
        </form>
    </div>
</div>