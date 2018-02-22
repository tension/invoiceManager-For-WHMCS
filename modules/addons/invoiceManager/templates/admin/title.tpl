{$notice}

<div class="tablebg">
    <table id="sortabletbl0" class="datatable" width="100%" border="0" cellspacing="1" cellpadding="3">
        <tr>
            <th width="200"><a href="{$modulelinks}&page=title&orderby=userid&asc">客户名称</a></th>
            <th><a href="{$modulelinks}&page=title&orderby=name&asc">抬头名称</a></th>
            <th width="120"><a href="{$modulelinks}&page=title&orderby=type&asc">发票种类</a></th>
            <th width="50"><a href="{$modulelinks}&page=title&orderby=status&asc">状态</a></th>
            <th width="20">操作</th>
        </tr>
        {if $title['result']}
            {foreach $title['result'] as $value}
                <tr>
                    <td><a href="clientssummary.php?userid={$value['userid']}" target="_blank">{$value['userinfo']['firstname']} {$value['userinfo']['lastname']}</a></td>
                    <td>{$value['name']|truncate:15:""}</a></td>
                    <td class="text-center">增值税{if $value['type'] eq 'standard'}普通{else}专用{/if}发票</td>
                    <td class="text-center">
	                    <span class="text-{$value['status']}">{if $value['status'] eq 'warning'}待审{elseif $value['status'] eq 'success'}可用{else}驳回 <i class="fa fa-info-circle" data-toggle="tooltip" data-placement="top" title="{$value['remark']}"></i>{/if}</span>
	                </td>
                    <td class="text-right"><a href="{$modulelinks}&page=title&action=detail&id={$value['id']}" class="btn btn-xs btn-primary">查看</a></td>
                </tr>
            {/foreach}
        {/if}
    </table>
    {if !$title}
        <div class="none-data text-center">
            <div class="no-data-info">
                <i class="fa fa-exclamation-triangle"></i> {$message}
            </div>
        </div>
    {/if}
</div>

{if $title['previous'] || $title['next']}
    <div style="clear: both;height: 20px;"></div>
    <ul class="pager" style="margin: 0;">
        {if $title['previous']}
            <li class="previous">
                <a href="{$modulelinks}&page=title&pagenum={$title['previous']}{if $title['asc']}&asc{/if}"><i class="fa fa-caret-left" aria-hidden="true"></i> 上一页</a>
            </li>
        {/if}
        {if $title['next']}
            <li class="next">
                <a href="{$modulelinks}&page=title&pagenum={$title['next']}{if $title['asc']}&asc{/if}">下一页 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
            </li>
        {/if}
    </ul>
{/if}