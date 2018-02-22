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
<div class="table-container clearfix">
    <table class="table table-list js-dataTable-full no-footer">
        <thead>
            <tr>
                <th style="text-align: left;">快递名称</th>
                <th>快递单号</th>
                <th>项目名称</th>
                <th class="text-right" data-orderable="false">操作</th>
            </tr>
        </thead>
        {if $express}
        <tbody>
        {foreach $express as $value}
            <tr>
                <td>{$value['expressName']}</td>
                <td>{$value['code']}</td>
                <td>{$value['name']|truncate:15:""}</td>
                <td class="text-right"><a href="{$systemurl}?m=invoiceManager&page=express&action=detail&id={$value['id']}" class="btn btn-xs btn-primary">查看</a></td>
            </tr>
        {/foreach}
        </tbody>
        {/if}
    </table>
</div>