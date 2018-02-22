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
function Delete (title, text, id) {
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
		location='{$WEB_ROOT}/?m=invoiceManager&page=address&action=delete&id='+id
	});
}
</script>
<div class="alert alert-info">
		<i class="fa fa-info-circle"></i>
		您还可以增加收件地址，<a href="{$systemurl}?m=invoiceManager&page=address&action=editor" class="btn btn-default btn-xs">立即设置</a>
</div>
<div class="table-container clearfix">
    <table class="table table-list js-dataTable-full no-footer">
        <thead>
            <tr>
                <th>收件姓名</th>
                <th>电话号码</th>
                <th>地址</th>
                <th class="text-right" data-orderable="false">操作</th>
            </tr>
        </thead>
        {if $address}
        <tbody>
            {foreach $address as $value}
                <tr>
                    <td>{$value['name']}</td>
                    <td>{if $value['phone']}{$value['phone']}{else}{$value['mobile']}{/if}</td>
                    <td>{$value['province']}{$value['address']|truncate:15:""}</td>
                    <td class="text-right">
                        <a href="{$systemurl}?m=invoiceManager&page=address&action=editor&id={$value['id']}" class="btn btn-xs btn-primary">修改</a>
                        <button onClick="Delete('删除确认','你确定要删除此地址吗？','{$value['id']}');" class="btn btn-xs btn-danger">删除</button>
                    </td>
                </tr>
            {/foreach}
        </tbody>
        {/if}
    </table>
</div>