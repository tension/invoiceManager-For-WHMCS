{$notice}

<div class="tablebg">
    <table id="sortabletbl0" class="datatable" width="100%" border="0" cellspacing="1" cellpadding="3">
        <tr>
            <th><a href="{$modulelinks}&orderby=userid&asc">客户名称</a></th>
            <th><a href="{$modulelinks}&orderby=name&asc">发票抬头</a></th>
            <th><a href="{$modulelinks}&orderby=amount&asc">发票金额</a></th>
            <th><a href="{$modulelinks}&orderby=type&asc">发票种类</a></th>
            <th><a href="{$modulelinks}&orderby=status&asc">状态</a></th>
            <th><a href="{$modulelinks}&orderby=timestamp&asc">申请时间</a></th>
            <th>操作</th>
        </tr>
        {if $invoice['result']}
            {foreach $invoice['result'] as $value}
                <tr>
                    <td><a href="clientssummary.php?userid={$value['userid']}" target="_blank">{$value['userinfo']['firstname']} {$value['userinfo']['lastname']}</a></td>
                    <td>{$value['name']|truncate:15:""}</a></td>
                    <td>&yen; {$value['amount']}</a></td>
                    <td>增值税{if $value['type'] eq 'standard'}普通{else}专用{/if}发票</td>
                    <td>
	                    {if $value['status'] eq 'warning'}
	                    	<span style="font-weight:bold;color:#888888">待开票</span>
	                    {elseif $value['status'] eq 'success'}
	                    	<span style="font-weight:bold;color:#779500">已开票</span>
	                    {else}
	                    	<span style="font-weight:bold;color:#D8534F">已作废</span>
	                    {/if}
	                </td>
                    <td>{$value['timestamp']}</td>
                    <td class="text-right">
	                	<a href="{$modulelinks}&page=invoice&action=detail&id={$value['id']}" class="btn btn-xs btn-primary">详情</a>
	                	
	                	<button onClick="javascript:swal({
  title: '发票作废',
  text: '你确定作废这条开票记录吗？',
  type: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#DD6B55',
  confirmButtonText: '确定',
  cancelButtonText: '取消',
  closeOnConfirm: false
},
function(){
	location='{$modulelinks}&page=invoice&action=cancel&id={$value['id']}'
});" class="btn btn-xs btn-danger {if $value['status'] eq 'danger'} disabled{/if}">作废</button>
	                    </td>
                </tr>
            {/foreach}
        {/if}
    </table>
    {if !$invoice}
        <div class="none-data text-center">
            <div class="no-data-info">
                <i class="fa fa-exclamation-triangle"></i> {$message}
            </div>
        </div>
    {/if}
</div>

{if $invoice['previous'] || $invoice['next']}
    <div style="clear: both;height: 20px;"></div>
    <ul class="pager" style="margin: 0;">
        {if $invoice['previous']}
            <li class="previous">
                <a href="{$modulelinks}&pagenum={$invoice['previous']}{if $invoice['asc']}&asc{/if}"><i class="fa fa-caret-left" aria-hidden="true"></i> 上一页</a>
            </li>
        {/if}
        {if $invoice['next']}
            <li class="next">
                <a href="{$modulelinks}&pagenum={$invoice['next']}{if $invoice['asc']}&asc{/if}">下一页 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
            </li>
        {/if}
    </ul>
{/if}