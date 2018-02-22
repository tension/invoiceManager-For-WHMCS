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
<form action="{$modulelinks}&amp;page=express_search" method="post">
    <table class="form" width="100%" border="0" cellspacing="2" cellpadding="3">
        <tbody>

        <tr>
            <td class="fieldlabel">快递名称</td>
            <td class="fieldarea">
                <select name="express" class="form-control select-inline">
                    <option value="">全部</option>
                    {if $express|count > 0}
                        {foreach $express as $value}
                            <option value="{$value['id']}"{if $post['express'] eq $value['name']} selected{/if}>{$value['name']}</option>
                        {/foreach}
                    {/if}
                </select>
            </td>

            <td class="fieldlabel">快递单号</td>
            <td class="fieldarea">
                <input type="text" name="code" class="form-control input-200" value="{$post['code']}">
            </td>
        </tr>

        <tr>
            <td class="fieldlabel">开始日期</td>
            <td class="fieldarea"><input type="text" name="startdate" value="{$post['startdate']}" class="form-control date-picker"></td>
            <td class="fieldlabel">结束日期</td>
            <td class="fieldarea"><input type="text" name="orderdate" value="{$post['orderdate']}" class="form-control date-picker"></td>
        </tr>

        <tr>
            <td class="fieldlabel">项目名称</td>
            <td class="fieldarea">
                <input type="text" name="name" class="form-control input-200" value="{$post['name']}">
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
	                <th>项目名称</th>
	                <th>运单编号</th>
	                <th>运单价格</th>
	                <th>申请时间</th>
	                <th data-orderable="false">操作</th>
	            </tr>
	        </thead>
	        <tbody>
            {foreach $result['result'] as $value}
                <tr>
                    <td>
                        <a href="clientssummary.php?userid={$value['id']}">{$value['userinfo']['firstname']} {$value['userinfo']['lastname']}</a>
                    </td>
                    <td>{$value['name']|truncate:15:""}</td>
                    <td>{$value['code']}</td>
                    <td><span class="price">{$value['amount']}</span></td>
                    <td>{$value['timestamp']}</td>
                    <td>
                        <a href="{$modulelinks}&page=express&action=detail&id={$value['id']}" class="btn btn-xs btn-primary" target="_blank">查看</a>
                    </td>
                </tr>
            {/foreach}
	        </tbody>
        </table>
    </div>
    <p class="text-right"><strong>总计金额：{$result['amount']} 元</strong></p>
{/if}
