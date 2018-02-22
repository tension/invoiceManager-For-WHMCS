{$notice}
<!-- Page JS Plugins CSS -->
<link rel="stylesheet" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/datatables/jquery.dataTables.min.css">

<!-- Page JS Plugins -->
<script src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/datatables/jquery.dataTables.min.js"></script>

<!-- Page JS Code -->
<script src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/javascripts/base_tables_datatables.js"></script>
<style>
.dataTable thead .sorting:after, .dataTable thead .sorting_asc:after {
	top: 4px !important;
}
</style>
<script>
    var datepickerformat = "yy-mm-dd";
jQuery(document).ready( function () {
    jQuery(".dataTables_filter input").attr("placeholder", "输入要搜索的内容…");
});
</script>
<form action="{$modulelinks}&amp;page=invoice_search" method="post">
    <table class="form" width="100%" border="0" cellspacing="2" cellpadding="3">
        <tbody>
        <tr>
            <td width="15%" class="fieldlabel">
                发票抬头
            </td>
            <td class="fieldarea">
                <input type="text" name="name" class="form-control input-200" value="{$post['name']}">
            </td>
            <td width="15%" class="fieldlabel">
                发票编号
            </td>
            <td class="fieldarea">
                <input type="text" name="invoice" class="form-control input-200" value="{$post['invoice']}">
            </td>
        </tr>

        <tr>
            <td class="fieldlabel">
                开始日期
            </td>

            <td class="fieldarea">
                <input type="text" name="startdate" value="{$post['startdate']}" class="form-control date-picker">
            </td>

            <td class="fieldlabel">
                结束日期
            </td>

            <td class="fieldarea">
                <input type="text" name="orderdate" value="{$post['orderdate']}" class="form-control date-picker">
            </td>
        </tr>
        <tr>
            <td class="fieldlabel">
                发票类型
            </td>
            <td class="fieldarea">
                <select name="type" class="form-control select-inline">
                    <option value=""{if !$post['type']} selected{/if}>全部</option>
                    <option value="standard"{if $post['type'] eq 'standard'} selected{/if}>增值税普通发票</option>
                    <option value="special"{if $post['type'] eq 'special'} selected{/if}>增值税专用发票</option>
                </select>
            </td>
            <td class="fieldlabel">
                发票状态
            </td>
            <td class="fieldarea">
                <select name="status" class="form-control select-inline">
                    <option value=""{if !$post['status']} selected{/if}>全部</option>
                    <option value="success"{if $post['status'] eq 'success'} selected{/if}>已开票</option>
                    <option value="warning"{if $post['status'] eq 'warning'} selected{/if}>待开票</option>
                    <option value="danger"{if $post['status'] eq 'danger'} selected{/if}>已作废</option>
                </select>
            </td>
        </tr>
        </tbody>
    </table>
    <div class="btn-container">
        <input type="submit" value="搜索" class="btn btn-success" />
    </div>
</form>

{if $result['result']}
    <div class="tablebg">
        <table class="datatable js-dataTable-full" width="100%" border="0" cellspacing="1" cellpadding="3">
	        <thead>
	            <tr>
	                <th>客户名称</th>
	                <th>发票抬头</th>
	                <th>发票金额</th>
	                <th>发票种类</th>
	                <th>申请时间</th>
	                <th>状态</th>
	                <th data-orderable="false">操作</th>
	            </tr>
	        </thead>
	        <tbody>
            {foreach $result['result'] as $value}
                <tr>
                    <td>
                        <a href="clientssummary.php?userid={$value['id']}">{$value['userinfo']['firstname']} {$value['userinfo']['lastname']}</a>
                    </td>
                    <td>
                        {$value['name']|truncate:15:""}
                    </td>
                    <td>
                        <span class="price">{$value['amount']}</span>
                    </td>
                    <td>
                        增值税{if $value['type'] eq 'standard'}普通{else}专用{/if}发票
                    </td>
                    <td>
                        {$value['timestamp']}
                    </td>
                    <td class="text-center">
                        <span class="text-{$value['status']}">{if $value['status'] eq 'warning'}等待开票{elseif $value['status'] eq 'success'}已开发票{elseif $value['status'] eq 'danger'}发票作废{else}未知{/if}</span>
                    </td>
                    <td>
                        <a href="{$modulelinks}&page=invoice&action=detail&id={$value['id']}" class="btn btn-xs btn-primary" target="_blank">查看</a>
                    </td>
                </tr>
            {/foreach}
	        </tbody>
        </table>
    </div>
    <p class="text-right"><strong>总计金额：{$result['amount']} 元</strong></p>
{/if}
