<div class="panel panel-default panel-table">
    <div class="panel-heading">
        <h3 class="panel-title">开票明细</h3>
    </div>
    <div class="panel-body" style="padding: 0;">
	    <table class="table no-footer table-detail">
		    <tbody>
				<tr>
					<td colspan="2">
						<label class="control-label">发票抬头：</label>
						<span class="margin-left-2">{$detail['name']}</span>
					</td>
				</tr>
				<tr>
					<td width="50%">
						<label class="control-label">发票金额：</label>
						<span class="margin-left-2 price">{$detail['amount']}</span>
					</td>
					<td>
						<label class="control-label">发票类型：</label>
						<span class="margin-left-2">增值税{if $detail['type'] eq 'standard'}普通{else}专用{/if}发票</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="control-label">发票状态：</label>
						<span class="margin-left-2 text-{$detail['status']}">{if $detail['status'] eq 'warning'}等待开票{elseif $detail['status'] eq 'success'}已开发票{elseif $detail['status'] eq 'danger'}发票作废{else}未知状态{/if}</span>
					</td>
					<td>
						<label class="control-label">发票编号：</label>
						<span class="margin-left-2">{if $detail['invoice']}{$detail['invoice']}{else}暂未开票{/if}</span>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<label class="control-label">申请时间：</label>
						<span class="margin-left-2">{$detail['timestamp']}</span>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<label class="control-label">收件人名：</label>
						<span class="margin-left-2">{$detail['address']['name']}</span>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<label class="control-label">收件地址：</label>
						<span class="margin-left-2">{$detail['address']['province']}{$detail['address']['address']}</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="control-label">收件手机：</label>
						<span class="margin-left-2">{$detail['address']['mobile']}</span>
					</td>
					<td>
						<label class="control-label">收件电话：</label>
						<span class="margin-left-2">{$detail['address']['phone']}</span>
					</td>
				</tr>
		    </tbody>
	    </table>
    </div>
</div>

{if $detail['invoices']}
<div class="panel panel-default panel-table">
    <div class="panel-heading">
        <h3 class="panel-title">关联账单</h3>
    </div>
    <div class="panel-body" style="padding: 0;">
        <table class="table table-list no-footer">
            <thead>
				<tr>
                    <th>账单编号</th>
                    <th>产品名称</th>
                    <th>消费金额</th>
                    <th>支付方式</th>
                    <th>支付日期</th>
                </tr>
            </thead>
            <tbody>
	            {foreach $detail['invoices'] as $value}
	            <tr>
		            <td>{$value['id']}</td>
		            <td>{$value['name']}</td>
		            <td class="price">{$value['amount']}</td>
		            <td>{$value['payment']}</td>
		            <td>{$value['date']}</td>
		        </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
{/if}
{if $detail['track']}
<div class="panel panel-default">
    <div class="panel-heading">
        <h4 class="panel-title">物流详情</h4>
    </div>
    <div class="panel-body">
		<div class="track-list">
			<ul class="list-unstyled">
	        {if $detail['track']|count > 1}
	            {foreach $detail['track'] as $value}
	                <li>
						<i class="node-icon"></i>
						<span class="time">{$value['AcceptTime']}</span>
						<span class="txt">{$value['AcceptStation']}</span>
	                </li>
	            {/foreach}
	        {else}
	            {$detail['track']}
	        {/if}
			</ul>
		</div>
    </div>
</div>
{/if}