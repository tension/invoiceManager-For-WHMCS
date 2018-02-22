{$notice}
<link rel="stylesheet" type="text/css" href="{$BASE_PATH_CSS}/dataTables.bootstrap.css">
<link rel="stylesheet" type="text/css" href="{$BASE_PATH_CSS}/dataTables.responsive.css">
<script type="text/javascript" charset="utf8" src="{$BASE_PATH_JS}/jquery.dataTables.min.js"></script>
<script type="text/javascript" charset="utf8" src="{$BASE_PATH_JS}/dataTables.bootstrap.min.js"></script>
<script type="text/javascript" charset="utf8" src="{$BASE_PATH_JS}/dataTables.responsive.min.js"></script>
<script type="text/javascript">
var alreadyReady = false; // The ready function is being called twice on page load.
jQuery(document).ready( function () {
    var table = jQuery(".js-dataTable-full").DataTable({
        "dom": '<"listtable"fit>pl',
        "responsive": true,
        "oLanguage": {
            "sEmptyTable":     "{$LANG.norecordsfound}",
            "sInfo":           "{$LANG.tableshowing}",
            "sInfoEmpty":      "{$LANG.norecordsfound}",
            "sInfoFiltered":   "{$LANG.tablefiltered}",
            "sInfoPostFix":    "",
            "sInfoThousands":  ",",
            "sLengthMenu":     "{$LANG.tablelength}",
            "sLoadingRecords": "{$LANG.tableloading}",
            "sProcessing":     "{$LANG.tableprocessing}",
            "sSearch":         "",
            "sZeroRecords":    "{$LANG.norecordsfound}",
            "oPaginate": {
                "sFirst":    "{$LANG.tablepagesfirst}",
                "sLast":     "{$LANG.tablepageslast}",
                "sNext":     "{$LANG.tablepagesnext}",
                "sPrevious": "{$LANG.Previous}"
            }
        },
        "pageLength": 10,
        "order": [
            [ 0, "asc" ]
        ],
        "lengthMenu": [
            [10, 20, 30, -1],
            [10, 20, 30, "{$LANG.tableviewall}"]
        ],
        "aoColumnDefs": [
            {
                "bSortable": false,
                "aTargets": [  ]
            },
            {
                "sType": "string",
                "aTargets": [ 3 ]
            }
        ],
        "stateSave": true
    });
    jQuery(".dataTables_filter input").attr("placeholder", "{$LANG.tableentersearchterm}");

        // highlight remembered filter on page re-load
    var rememberedFilterTerm = table.state().columns[3].search.search;
    if (rememberedFilterTerm && !alreadyReady) {
        // This should only run on the first "ready" event.
        jQuery(".view-filter-btns a span").each(function(index) {
            if (buildFilterRegex(jQuery(this).text().trim()) == rememberedFilterTerm) {
                jQuery(this).parent('a').addClass('active');
                jQuery(this).parent('a').find('i').removeClass('fa-circle-o').addClass('fa-dot-circle-o');
            }
        });
    }
    alreadyReady = true;
} );

function Cancel( title, text, id ) {
	swal({
		title: title,
		text: text,
		type: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#DD6B55',
		confirmButtonText: '确定',
		cancelButtonText: '取消',
		closeOnConfirm: false
	},
	function(){
		location='{$WEB_ROOT}/?m=invoiceManager&page=invoice&action=cancel&id='+id
	});
}
</script>
<div class="alert alert-info">
		<i class="fa fa-info-circle"></i>
		在发票处于等待开票状态下、并且提交时间不超过 30 分钟时，可以作废此发票。
</div>
<div class="table-container clearfix">
    <table class="table table-list js-dataTable-full no-footer">
        <thead>
	        <tr>
	            <th>发票编号</th>
	            <th>发票抬头</th>
	            <th>发票金额</th>
	            <th>状态</th>
	            <th>申请时间</th>
	            <th width="100" class="text-right" data-orderable="false">操作</th>
	        </tr>
        </thead>
        {if $invoice}
        <tbody>
        {foreach $invoice as $value}
            <tr>
                <td>{if $value['invoice']}{$value['invoice']}{else}暂未开票{/if}</td>
                <td>{$value['name']|truncate:15:""}</td>
                <td>&yen; {$value['amount']}</td>
                <td><span class="text-{$value['status']}">{if $value['status'] eq 'warning'}等待开票{elseif $value['status'] eq 'success'}已开发票{elseif $value['status'] eq 'danger'}发票作废{else}未知{/if}</span></td>
                <td>{$value['timestamp']|date_format:'Y-m-d H:i'}</td>
                <td class="text-right">
                    {if $value['status'] eq 'warning' && (( $smarty.now - $value['timestamp']|strtotime ) < 1800)}
                    <button onClick="Cancel('发票作废','你确定作废这个发票申请吗？','{$value['id']}');" class="btn btn-xs btn-danger">作废</button>
                    {/if}
                    <a href="{$WEB_ROOT}/?m=invoiceManager&page=invoice&action=detail&id={$value['id']}" class="btn btn-xs btn-primary">查看</a>
                </td>
            </tr>
        {/foreach}
        </tbody>
        {/if}
    </table>
</div>