<div class="empty" style="height: 20px;"></div>

<div class="row">
    <div class="col-sm-8">
        <div class="panel panel-default panel-table">
            <div class="panel-heading">
	            <a class="btn btn-xs btn-info pull-right" href="{$modulelinks}&page=express&action=print&id={$express['id']}" target="_blank"><i class="fa fa-print"></i> 打印快递单</a>
                <h3 class="panel-title">
                    快递信息
                </h3>
            </div>
			<div class="panel-body" style="padding: 0;">
				<table class="table no-footer table-detail">
					<tbody>
						<tr>
							<td width="50%">
								<label class="control-label">项目名称：</label>
								<span class="margin-left-2">{$express['name']}</span>
							</td>
							<td>
								<label class="control-label">快递名称：</label>
								<span class="margin-left-2">{$express['expressName']}</span>
							</td>
						</tr>
						<tr>
							<td>
								<label class="control-label">收件人名：</label>
								<span class="margin-left-2">{$express['address']['name']}</span>
							</td>
							<td>
								<label class="control-label">收件电话：</label>
								<span class="margin-left-2">{$express['address']['mobile']}{if $express['address']['phone']}, {$express['address']['phone']}{/if}</span>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<label class="control-label">收件地址：</label>
								<span class="margin-left-2">{$express['address']['province']}{$express['address']['address']}</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
        </div>
    
		<div class="panel panel-default">
		    <div class="panel-heading">
		        <h3 class="panel-title">物流详情</h3>
		    </div>
		    <div class="panel-body">
				<div class="track-list">
					<ul class="list-unstyled">
			        {if $express['track']|count > 1}
			            {foreach $express['track'] as $value}
			                <li>
								<i class="node-icon"></i>
								<span class="time">{$value['AcceptTime']}</span>
								<span class="txt">{$value['AcceptStation']}</span>
			                </li>
			            {/foreach}
			        {else}
			            <li class="none">{$express['track']}</li>
			        {/if}
					</ul>
				</div>
		    </div>
		</div>
		
    </div>

    <div class="col-sm-4">

        <div class="panel panel-primary invoices-info">
            <div class="panel-heading">
                <h4 class="panel-title">快递信息</h4>
            </div>
            <form action="{$modulelinks}&page=express&action=list" method="POST">
                <input type="hidden" value="{$express['id']}" name="id"/>
                <div class="panel-body">
                    <label>项目名称：</label>
                    <input type="text" name="name" value="{$express['name']}" class="form-control" placeholder="请输入项目名称" style="margin-bottom: 8px;" />
                    <label>运单编号：</label>
                    <input type="text" name="code" value="{$express['code']}" class="form-control" placeholder="请输入运单编号" style="margin-bottom: 8px;" />
                    <label>运单价格：</label>
                    <input type="text" name="amount" value="{$express['amount']}" class="form-control" placeholder="请输入运单价格" style="margin-bottom: 8px;" />
                    <label>选择快递：</label>
                    {if $setting|count >= 1}
                        <select name="express" class="form-control selectize">
                            {foreach $setting as $value}
                                <option value="{$value['id']}"{if $express['expressName'] eq $value['name']} selected{/if}>{$value['name']}</option>
                            {/foreach}
                        </select>
                    {else}
                        当前尚未设置快递
                    {/if}

                    <div class="empty" style="height: 20px;"></div>

                    <button type="submit" class="btn btn-success btn-block">提交修改</button>
                </div>
            </form>
        </div>
    </div>
</div>