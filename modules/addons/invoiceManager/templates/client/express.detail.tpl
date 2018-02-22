
<div class="panel panel-default panel-table">
    <div class="panel-heading">
        <h3 class="panel-title">快递详情：<small>{$detail['name']}</small></h3>
    </div>
    <div class="panel-body" style="padding: 0;">
	    <table class="table no-footer table-detail">
		    <tbody>
				<tr>
					<td width="50%">
						<label class="control-label">物流公司：</label>
						<span class="margin-left-2">{$detail['expressName']}</span>
					</td>
					<td>
						<label class="control-label">快递编号：</label>
						<span class="margin-left-2">{$detail['code']}</span>
					</td>
				</tr>
				<tr>
					<td>
						<label class="control-label">收件人名：</label>
						<span class="margin-left-2">{$detail['address']['name']}</span>
					</td>
					<td>
						<label class="control-label">发件时间：</label>
						<span class="margin-left-2">{$detail['timestamp']}</span>
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
				<tr>
					<td colspan="2">
						<label class="control-label">收件地址：</label>
						<span class="margin-left-2">{$detail['address']['province']}{$detail['address']['address']}</span>
					</td>
				</tr>
		    </tbody>
	    </table>
    </div>
</div>

<div class="panel panel-default">
    <div class="panel-heading">
        <h4 class="panel-title">物流详情：</h4>
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