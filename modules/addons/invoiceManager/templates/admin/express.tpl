<style>
    .none-data {
        margin: 50px 0;
    }
    .no-data-info .fa {
        color: #D32E1D;
        font-weight: 400;
        vertical-align: middle;
    }
    #tableInvoicePlusList tr.selected {
	    background-color: #F5F5F5;
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
    var addressid = $('[name="addressid"]').val();
    var expressnum = $('[name="expressnum"]').val();
    var invoice = $('#invoice').val();

    // 判断是否为空
    if (addressid.length == 0 && invoice.length == 0) {
	    sweetAlert({ title: "错误", text: "你尚未勾选信息", type: "error", confirmButtonText: "确定" });
    }else if (expressnum.length == 0) {
	    sweetAlert({ title: "错误", text: "你尚未填写快递单号", type: "error", confirmButtonText: "确定" });
	} else {
        // 提交表单
        $('#addForm').submit();
    }
}

function updateExpress(obj, userid, title, invoice, province, address, name, mobile, phone) {
	
	$('#tableInvoicePlusList tr').removeClass("selected");
	obj.className = 'selected';
	
	$('#name').text(name);
	$('#phone').text(mobile +' '+phone);
	$('#addrs').text(address);
	
	$('input[name=expressname]').val(title);
	$('#userid').val(userid);
	$('#invoice').val(invoice);
	$('#province').val(province);
	
	updatePrice( province );
}

function updatePrice() {
	$.getJSON(
	    "{$modulelinks}&page=amount",{
	        express: $('#express').val(),
	        province: $('#province').val(),
	    },function(data){
	        if ( data.status == 'error' ) {
	        	alert(data.info);
	        } else {
		        $('#total').val(data.result);
	        }
	    }
	);
}

$(function(){

    $('.selectize').selectize();

    // 选择用户后触发
    $('#selectUserid').change(function(){

        var userID = $(this).val();
        if ( userID != '' ) {

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
                        
                        $('.addInvoice-addr').html('');
                        // 正常
                        var address 		= data.result.address;

                        if ( address ) {
                            var addhtml = '';
                            $.each(address, function (n, val) {
                                addhtml += '<div class="col-sm-6" data-name="'+val.name+'" data-id="'+val.id+'" data-mobile="'+val.mobile+'" data-tel="'+val.phone+'" data-addr="'+val.province + val.address+'" data-province="'+val.province+'">';
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
                                $('#province').val($(this).data('province'));
                                
								updatePrice();
                                
                            });
                        } else {

                            $('.addInvoice-addr .none-data').hide();
                            $('.addInvoice-addr').append('<div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何地址信息</a></div></div>');
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
<div class="row detail">
    <div class="col-sm-8">
	    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
          <i class="fa"></i> 已开发票列表 
        </a>
      </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
        <div class="panel-body" style="padding: 0;" id="tableList">
            <table id="tableInvoicePlusList" class="table table-list dataTable no-footer dtr-inline" role="grid">
                <thead>
                <tr role="row">
                    <th>发票抬头</th>
                    <th width="120">发票类型</th>
                    <th width="100">发票编号</th>
                    <th>发票金额</th>
                    <th>申请时间</th>
                </tr>
                </thead>
                {if $invoices}
                    <tbody>
                    {foreach $invoices as $value}
                        <tr style="cursor: pointer;" onClick="updateExpress(this, '{$value['userid']}', '{$value['name']}', '{$value['id']}', '{$value['address']['province']}', '{$value['address']['province']}{$value['address']['address']}', '{$value['address']['name']}', '{$value['address']['mobile']}', '{$value['address']['phone']}');">
                            <td>{$value['name']|truncate:15:""}</td>
                            <td>增值税{if $value['type'] eq 'standard'}普通{else}专用{/if}发票</td>
                            <td>{$value['invoice']}</td>
                            <td><span class="price">{$value['amount']}</span></td>
                            <td>{$value['timestamp']}</td>
                        </tr>
                    {/foreach}
                    </tbody>
                {/if}
            </table>
            {if !$invoices}<div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 当前系统中没有未开快递的发票信息</a></div></div>{/if}
        </div>
        <!-- Panel End -->
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingTwo">
      <h4 class="panel-title">
        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
          <i class="fa fa-plus-square-o"></i> 查找联系人
        </a>
      </h4>
    </div>
    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
		<div class="panel-body">
	    
		<div class="row client-dropdown-container">
		    <div class="col-sm-12">
		        <select id="selectUserid" name="userid" class="form-control selectize-client-search" placeholder="输入查询的客户名或ID、邮箱" data-value-field="id" tabindex="-1">
		            <option value=""></option>
		        </select>
		    </div>
		</div>
			
	        <div class="row">
		    	<div class="col-sm-12 addInvoice admin">
	                <div class="row addInvoice-addr">
	                    <div class="none-data text-center"><div class="no-data-info"><i class="fa fa-exclamation-triangle"></i> 还没有任何地址信息</a></div></div>
	                </div>
		    	</div>
	        </div>
        </div>
    </div>
  </div>
</div>
    </div>
    <form action="{$modulelinks}&page=express" method="POST" id="addForm">
    <div class="col-sm-4">
        <div class="panel panel-primary invoices-info">
            <div class="panel-heading">
                <h4 class="panel-title">快递信息</h4>
            </div>
            <div class="panel-body">
                <p>
                    <label class="control-label">收件姓名：</label>
                    <span id="name"></span>
                </p>
                <p>
                    <label class="control-label">收件电话：</label>
                    <span id="phone"></span>
                </p>
                <p>
                    <label class="control-label">收件地址：</label>
                    <span id="addrs"></span>
                </p>
                <hr/>
	            <div class="form-group" style="margin: 0;">
                   	<label class="control-label pull-left" style="line-height: 30px;margin: 0;">快递金额：</label>
                    <div class="row">
	                    <div class="col-xs-3">
		                	<input type="text" name="amount" id="total" class="form-control input-sm" />
	                    </div>
                    </div>
	            </div>
            </div>
        </div>
        <input type="hidden" name="userid" value="" id="userid" />
        <input type="hidden" name="addressid" value="" id="addressid" />
        <input type="hidden" name="invoice" value="" id="invoice" />
        <input type="hidden" name="province" value="" id="province" />
        <div class="panel panel-primary invoices-info">
            <div class="panel-heading">
                <h4 class="panel-title">其他信息</h4>
            </div>
            <div class="panel-body">
	            <div class="form-group">
                    <label>项目名称：</label>
                    <input type="text" name="expressname" class="form-control" placeholder="请输入项目名称" />
	            </div>
                <div class="form-group">
                    <label>选择快递：</label>
                {if $express|count >= 1}
                        <select name="expressid" class="form-control selectize" id="express" onchange="updatePrice()">
                            {foreach $express as $value}
                                <option value="{$value['id']}">{$value['name']}</option>
                            {/foreach}
                        </select>
                {else}
                    当前尚未设置快递
                {/if}
                </div>
	            <div class="form-group">
                    <label>快递单号：</label>
                    <input type="text" name="expressnum" class="form-control" placeholder="请输入快递编号" />
	            </div>
            </div>
        </div>
        <button type="button" class="btn btn-primary btn-block" onclick="checkValue();">确认</button>
    </div>
    </form>
</div>