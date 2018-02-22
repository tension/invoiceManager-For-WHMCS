{$notice}

<div class="tablebg">
    <table id="sortabletbl0" class="datatable" width="100%" border="0" cellspacing="1" cellpadding="3">
        <tr>
            <th><a href="{$modulelinks}&amp;page=title&amp;orderby=userid&amp;asc">客户名称</a></th>
            <th><a href="{$modulelinks}&amp;page=title&amp;orderby=name&amp;asc">项目名称</a></th>
            <th><a href="{$modulelinks}&amp;page=title&amp;orderby=express&amp;asc">快递名称</a></th>
            <th><a href="{$modulelinks}&amp;page=title&amp;orderby=code&amp;asc">运单编号</a></th>
            <th><a href="{$modulelinks}&amp;page=title&amp;orderby=amount&amp;asc">运单价格</a></th>
            <th>操作</th>
        </tr>
        {if $express['result']}
            {foreach $express['result'] as $value}
                <tr>
                    <td><a href="clientssummary.php?userid={$value['userid']}" target="_blank">{$value['userinfo']['firstname']} {$value['userinfo']['lastname']}</a></td>
                    <td>{$value['name']|truncate:15:""}</a></td>
                    <td>{$value['expressName']}</td>
                    <td>{$value['code']}</td>
                    <td><span class="price">{$value['amount']}</span></td>
                    <td class="text-right">
                        <a href="{$modulelinks}&amp;page=express&amp;action=detail&amp;id={$value['id']}" class="btn btn-xs btn-primary">详情</a>
                        <a href="{$modulelinks}&amp;page=express&amp;action=print&amp;id={$value['id']}" class="btn btn-xs btn-success" target="_blank">打印</a>
                    </td>
                </tr>
            {/foreach}
        {/if}
    </table>
    {if !$express}
        <div class="none-data text-center">
            <div class="no-data-info">
                <i class="fa fa-exclamation-triangle"></i> {$message}
            </div>
        </div>
    {/if}
</div>

{if $express['previous'] || $express['next']}
    <div style="clear: both;height: 20px;"></div>
    <ul class="pager" style="margin: 0;">
        {if $express['previous']}
            <li class="previous">
                <a href="{$modulelinks}&amp;page=express&amp;action=list&amp;pagenum={$express['previous']}{if $express['asc']}&amp;asc{/if}"><i class="fa fa-caret-left" aria-hidden="true"></i> 上一页</a>
            </li>
        {/if}
        {if $express['next']}
            <li class="next">
                <a href="{$modulelinks}&amp;page=express&amp;action=list&amp;pagenum={$express['next']}{if $express['asc']}&amp;asc{/if}">下一页 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
            </li>
        {/if}
    </ul>
{/if}
