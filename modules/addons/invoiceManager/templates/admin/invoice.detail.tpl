<div class="empty" style="height: 20px;"></div>
<script type="text/javascript">
function checkValue() {
    var invoice = $('[name="invoice"]').val();

	if ( $('[name=status]').val() != 'warning' ) {
	    // 判断是否为空
	    if (invoice.length == 0) {
		    sweetAlert({ title: "错误", text: "你尚未输入发票号", type: "error", confirmButtonText: "确定" });
		} else {
	        // 提交表单
	        $('#updateTitle').submit();
	    }
	} else {
        // 提交表单
        $('#updateTitle').submit();
	}
}
</script>

{$notice}

<div class="row">

	<div class="col-sm-{if $invoice['status'] eq 'danger'}12{else}8{/if}">

		<div class="panel panel-default panel-table">
			<div class="panel-heading">
				<h3 class="panel-title">
					开票明细
				</h3>
			</div>
			<div class="panel-body" style="padding: 0;">
				<table class="table no-footer table-detail">
					<tbody>
						<tr>
							<td colspan="2">
								<label class="control-label">发票抬头：</label>
								<span>{$invoice['name']}</span>
							</td>
						</tr>
						<tr>
							<td width="50%">
								<label class="control-label">发票金额：</label>
								<span class="margin-left-2 price">{$invoice['amount']}</span>
							</td>
							<td>
								<label class="control-label">发票编号：</label>
								<span>{if $invoice['invoice']}{$invoice['invoice']}{else}暂未开票{/if}</span>
							</td>
						</tr>
						<tr>
							<td>
								<label class="control-label">发票类型：</label>
								<span>增值税{if $invoice['type'] eq 'standard'}普通{else}专用{/if}发票</span>
							</td>
							<td>
								<label class="control-label">发票状态：</label>
								<span class="text-{$invoice['status']}">{if $invoice['status'] eq 'warning'}等待开票{elseif $invoice['status'] eq 'success'}已开发票{elseif $invoice['status'] eq 'danger'}发票作废{else}未知状态{/if}</span>
							</td>
						</tr>
						<tr>
							<td>
								<label class="control-label">纳税人识别号：</label>
								<span>{$invoice['title']['info_1']}</span>
							</td>
							<td>
								<label class="control-label">申请时间：</label>
								<span>{$invoice['timestamp']}</span>
							</td>
						</tr>
						{if $invoice['type'] neq 'standard'}
						<tr>
							<td>
								<label class="control-label">基本户银行名称：</label>
								<span>{$invoice['title']['info_2']}</span>
							</td>
							<td>
								<label class="control-label">基本户帐号：</label>
								<span>{$invoice['title']['info_3']}</span>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<label class="control-label">注册场所地址：</label>
								<span>{$invoice['title']['info_4']}</span>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<label class="control-label">注册固定电话：</label>
								<span>{$invoice['title']['info_5']}</span>
							</td>
						</tr>
						{/if}
						{if $invoice['address']}
						<tr>
							<td colspan="2">
								<label class="control-label">收件人名：</label>
								<span>{$invoice['address']['name']}</span>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<label class="control-label">收件地址：</label>
								<span>{$invoice['address']['province']}{$invoice['address']['address']}</span>
							</td>
						</tr>
						<tr>
							<td>
								<label class="control-label">收件手机：</label>
								<span>{$invoice['address']['mobile']}</span>
							</td>
							<td>
								<label class="control-label">收件电话：</label>
								<span>{$invoice['address']['phone']}</span>
							</td>
						</tr>
						{/if}
					</tbody>
				</table>
			</div>
		</div>
		{if $invoice['invoices']}
		<div class="panel panel-default panel-table">
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
					{if $invoice['invoices'] && $invoice['status'] neq 'danger'}
						<tbody>
						{foreach $invoice['invoices'] as $value}
							<tr>
								<td>{$value['id']}</td>
								<td>{$value['name']}</td>
								<td class="price">{$value['amount']}</td>
								<td>{$value['payment']}</td>
								<td>{$value['date']}</td>
							</tr>
						{/foreach}
						</tbody>
					{/if}
				</table>
			</div>
		</div>
		{/if}
		
		{if $invoice['track']}
		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h4 class="panel-title">物流详情</h4>
		    </div>
		    <div class="panel-body">
				<div class="track-list">
					<ul class="list-unstyled">
			        {if $invoice['track']|count > 1}
			            {foreach $invoice['track'] as $value}
			                <li>
								<i class="node-icon"></i>
								<span class="time">{$value['AcceptTime']}</span>
								<span class="txt">{$value['AcceptStation']}</span>
			                </li>
			            {/foreach}
			        {else}
			            {$invoice['track']}
			        {/if}
					</ul>
				</div>
		    </div>
		</div>
		{/if}

	</div>
	{if $invoice['status'] neq 'danger'}
		<div class="col-sm-4">

			<div class="panel panel-primary invoices-info">
				<div class="panel-heading">
					<h4 class="panel-title">审核信息</h4>
				</div>
				<form action="{$modulelinks}&page=invoice&action=detail&id={$invoice['id']}" method="POST" id="updateTitle">
					<input type="hidden" value="{$invoice['id']}" name="id"/>
					<div class="panel-body">
						<select name="status" class="form-control">
							<option value="success">已开票</option>
							<option value="warning">待开票</option>
						</select>

						<div class="empty" style="height: 20px;"></div>

						<input type="text" name="invoice" value="" class="form-control" placeholder="请输入开票号" style="margin-bottom: 8px;" />
						<button type="button" onClick="checkValue();" class="btn btn-success btn-block">提交修改</button>
					</div>
				</form>
			</div>
		</div>
	{/if}
</div>