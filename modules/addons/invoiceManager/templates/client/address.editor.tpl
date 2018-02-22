<div class="panel panel-default">
    <div class="panel-heading">
        <h3 class="panel-title">地址添加</h3>
    </div>
    <div class="panel-body">
        <form class="form-horizontal" id="addr" action="{$WEB_ROOT}/?m=invoiceManager&page=address" method="post">
            <input type="hidden" name="id" value="{$id}">
            <div class="form-group">
                <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 收件姓名：</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" value="{$detail['name']}" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 手机号码：</label>
                <div class="col-sm-4">
                    <input type="text" name="mobile" class="form-control" value="{$detail['mobile']}" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label">联系电话：</label>
                <div class="col-sm-4">
                    <input type="text" name="phone" class="form-control" value="{$detail['phone']}" />
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i>收件地址：</label>
	            <div id="distpicker3">
                	<div class="col-sm-2">
						<select id="s_province" name="s_province" class="form-control"></select>
                	</div>
                	{if !$id}
                	<div class="col-sm-2">
						<select id="s_city" name="s_city" class="form-control"></select>
                	</div>
                	<div class="col-sm-2">
						<select id="s_county" name="s_county" class="form-control"></select>
					</div>
					{else}
					<div class="col-sm-6">
						<input type="hidden" name="s_city" value="" />
						<input type="hidden" name="s_county" value="" />
						<input type="text" name="address" class="form-control" value="{$detail['address']}" />
					</div>
					{/if}
            	</div>
				<script src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/javascripts//distpicker.data.js"></script>
				<script src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/javascripts//distpicker.js"></script>
				
                <script type="text/javascript">
					$(function () {
					    $('#distpicker3').distpicker({
						    placeholder: false,
							{if $id}
					        province: '{$detail['province']}',
							{/if}
					    });
					});
	            </script>
            </div>
            {if !$id}
            <div class="form-group">
                <div class="col-sm-6 col-sm-offset-3">
                    <input type="text" name="address" class="form-control" value="{$detail['address']}" />
                </div>
            </div>
            {/if}
            <div class="form-group">
                <div class="col-sm-6 col-sm-offset-3">
                    <button type="submit" class="btn btn-primary">保存修改</button>
                    <a href="{$WEB_ROOT}/index.php?m=invoiceManager&page=address" class="btn btn-default">返回</a>
                </div>
            </div>
        </form>
    </div>
</div>