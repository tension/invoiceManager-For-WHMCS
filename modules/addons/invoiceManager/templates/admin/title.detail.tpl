<div class="empty" style="height: 20px;"></div>
<link rel="stylesheet" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/baguetteBox.css">
<script type="text/javascript" src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/baguetteBox.js"></script>
<div class="row">
    <div class="col-sm-8">
        <div class="panel panel-default panel-table">
            <div class="panel-heading">
                <h3 class="panel-title">
                    抬头信息
                </h3>
            </div>
            <div class="panel-body">
		        <div class="form-group">
		            <label class="col-sm-3 control-label">审核状态：</label>
		            <span class="margin-left-2">
			            {if $title['status'] eq 'warning'}
			            	<span class="label label-warning">待审</span>
			            {elseif $title['status'] eq 'success'}
			            	<span class="label label-success">可用</span>
			            {else}
			            	<span class="label label-danger">驳回</span>
			            {/if}
		            </span>
		        </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">抬头名称：</label>
                    <span class="margin-left-2">{$title['name']}</span>
                </div>
				{if $title['name'] neq '个人'}
                <div class="form-group">
                    <label class="col-sm-3 control-label">纳税人识别号：</label>
                    <span class="margin-left-2">{$title['info_1']}</span>
                </div>
                {/if}
                {if $title['type'] eq 'special'}
                    <div class="form-group">
                        <label class="col-sm-3 control-label">基本开户银行名称：</label>
                        <span class="margin-left-2">{$title['info_2']}</span>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">基本开户账号：</label>
                        <span class="margin-left-2">{$title['info_3']}</span>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">注册场所地址：</label>
                        <span class="margin-left-2">{$title['info_4']}</span>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">注册固定电话：</label>
                        <span class="margin-left-2">{$title['info_5']}</span>
                    </div>
                    <div class="form-group">
			            {if $title['file_1']}
			            <div class="col-sm-4 text-center">
			                营业执照
			                <div class="gallery">
			                    <a href="{$modulelinks}&page=title&action=detail&id={$title['id']}&img={$title['file_1']}" style="background-image: url('{$modulelinks}&page=title&action=detail&id={$title['id']}&img={$title['file_1']}')">
			                    </a>
			                </div>
			            </div>
			            {/if}
			            {if $title['file_2']}
			            <div class="col-sm-4 text-center">
			                税务登记证
			                <div class="gallery">
			                    <a href="{$modulelinks}&page=title&action=detail&id={$title['id']}&img={$title['file_2']}" style="background-image: url('{$modulelinks}&page=title&action=detail&id={$title['id']}&img={$title['file_2']}')">
			                    </a>
			                </div>
			            </div>
			            {/if}
			            {if $title['file_3']}
			            <div class="col-sm-4 text-center">
			                一般纳税人资格证
			                <div class="gallery">
			                    <a href="{$modulelinks}&page=title&action=detail&id={$title['id']}&img={$title['file_3']}" style="background-image: url('{$modulelinks}&page=title&action=detail&id={$title['id']}&img={$title['file_3']}')">
			                    </a>
			                </div>
			            </div>
			            {/if}
                    </div>
                {/if}
            </div>
        </div>
    </div>
    <div class="col-sm-4">

        <div class="panel panel-primary invoices-info">
            <div class="panel-heading">
                <h4 class="panel-title">审核信息</h4>
            </div>
            <form action="{$modulelinks}&page=title" method="POST">
                <input type="hidden" value="{$title['id']}" name="id"/>
                <div class="panel-body">
                    <select name="status" class="form-control">
                        <option value="success">已审核</option>
                        <option value="warning">待审核</option>
                        <option value="danger">已驳回</option>
                    </select>

                    <div class="empty" style="height: 20px;"></div>

                    <input type="text" name="remark" value="" class="form-control" placeholder="请输入备注信息" style="margin-bottom: 8px;" />
                    <button name="action" value="yes" class="btn btn-success btn-block">提交修改</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
window.onload = function() {
    baguetteBox.run('.gallery', {

        animation: 'fadeIn',
        fullScreen: 'false',

    });
};
</script>