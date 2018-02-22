<script type="text/javascript">

function checkValue() {
    var titleid = $('input[name="title"]:checked').val();
    var addressid = $('input[name="address"]:checked').val();

    // 判断是否为空
    if (!titleid) {
	    sweetAlert({ title: '错误',text: '你尚未勾选抬头信息',type: 'error', confirmButtonText: '确定' });
	} else if (!addressid) {
	    sweetAlert({ title: '错误',text: '你尚未勾选地址信息',type: 'error', confirmButtonText: '确定' });
	} else {
        // 提交表单
        $('.addInvoice').submit();
    }
}

</script>
<div class="panel panel-default panel-table">
    <div class="panel-heading">
        <h3 class="panel-title">
            <i class="fa fa-file-text"></i>&nbsp;发票申请
        </h3>
    </div>
    <form class="form-horizontal addInvoice" style="margin: 0;" method="post" action="{$systemurl}?m=invoiceManager&page=invoice&action=new">
        <input type="hidden" name="invoice" value="{foreach $info['invoice'] as $value}{$value},{/foreach}" />
        <div class="panel-body">
            <div class="col-sm-12" style="height: 20px;"></div>
            <div class="col-sm-8">
                您选择了 {$info['invoice']|count} 份账单开具发票 <small>(若选中多份账单，订单金额将合并开具在一张发票中)</small>
            </div>
            <div class="col-sm-4 text-right">
                开票金额合计： <span class="price font">{$info['amount']}</span>
            </div>
            <div class="col-sm-12" style="border-bottom: 1px solid #EEE;padding-top: 30px;"></div>
            <div class="col-sm-12">
                <h4>发票抬头</h4>
                <div class="row addInvoice-info">
                    {foreach $title as $value}
                    <div class="col-sm-6">
                        <div class="radio-main">
                            <input type="radio" name="title" value="{$value['id']}">
                            <strong>{$value['name']}</strong>
                            <small style="display: block;">增值税{if $value['type'] eq 'standard'}普通{else}专用{/if}发票</small>
                        </div>
                    </div>
                    {/foreach}
                </div>
            </div>
            <div class="col-sm-12">
                <h4>寄送地址</h4>
                <div class="row addInvoice-addr">
                    {foreach $address as $value}
                    <div class="col-sm-6">
                        <div class="radio-main">
                            <input type="radio" name="address" value="{$value['id']}">
                            <dl>
                                <dt>
                                    <em class="uname">{$value['name']}</em>
                                </dt>
                                <dd class="utel">
                                    {if $value['phone']}{$value['phone']}{else}{$value['mobile']}{/if}
                                </dd>
                                <dd class="uaddress">
                                    {$value['province']}{$value['address']}
                                </dd>
                            </dl>
                        </div>
                    </div>
                    {/foreach}
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-success" onClick="checkValue()">确认申请</button>
        </div>
    </form>
</div>