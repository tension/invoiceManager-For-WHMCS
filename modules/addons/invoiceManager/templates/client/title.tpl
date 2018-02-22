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
</script>
{if $count < 5}
<div class="alert alert-info">
	当前账户还可以设置 {5 - $count} 个抬头，<a href="{$WEB_ROOT}/?m=invoiceManager&page=title&action=editor" class="btn btn-default btn-xs">立即设置</a>
</div>
{/if}
<div class="table-container clearfix">
    <table class="table table-list js-dataTable-full no-footer">
        <thead>
        <tr>
            <th class="text-left">发票抬头</th>
            <th>发票类型</th>
            <th>状态</th>
            <th class="text-right" data-orderable="false">操作</th>
        </tr>
        </thead>
        {if $title}
        <tbody>
            {foreach $title as $value}
                <tr>
                    <td>{$value['name']}</td>
                    <td>增值税{if $value['type'] eq 'standard'}普通{elseif $value['type'] eq 'special'}专用{else}未知{/if}发票</td>
                    <td>
                        <span class="text-{$value['status']}">
                        {if $value['status'] eq 'warning'}
                        	待审
                        {elseif $value['status'] eq 'success'}
                        	可用
                        {else}
                        	驳回 <i class="fa fa-info-circle" data-toggle="tooltip" data-placement="top" title="{$value['remark']}"></i>
                        {/if}
                        </span>
                    </td>
                    <td class="text-right">
                        {if $value['status'] eq 'danger'}
                            <a href="{$WEB_ROOT}/?m=invoiceManager&page=title&action=editor&id={$value['id']}" class="btn btn-xs btn-success">修改</a>
                        {else}
                            <a href="{$WEB_ROOT}/?m=invoiceManager&page=title&action=detail&id={$value['id']}" class="btn btn-xs btn-primary">查看</a>
                        {/if}
                        <button onClick="javascript:swal({
title: '删除确认',
text: '你确定删除这个抬头信息吗？',
type: 'warning',
showCancelButton: true,
confirmButtonColor: '#DD6B55',
confirmButtonText: '确定',
cancelButtonText: '取消',
closeOnConfirm: false
},
function(){
location='{$WEB_ROOT}/?m=invoiceManager&page=title&action=delete&id={$value['id']}'
});" class="btn btn-xs btn-danger{if $value['status'] neq 'success' && $value['status'] neq 'danger'} disabled{/if}">删除</button>
                    </td>
                </tr>
            {/foreach}
        </tbody>
        {/if}
    </table>
</div>