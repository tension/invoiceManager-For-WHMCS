
<link rel="stylesheet" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/baguetteBox.css">
<script type="text/javascript" src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/baguetteBox.js"></script>
<div class="panel panel-default panel-table">
    <div class="panel-heading">
        <h3 class="panel-title">抬头信息</h3>
    </div>
    <div class="panel-body">
        <div class="form-group">
            <label class="col-sm-3 control-label">审核状态：</label>
            <span class="margin-left-2">
	            {if $detail['status'] eq 'warning'}
	            	<span class="label label-warning">待审</span>
	            {elseif $detail['status'] eq 'success'}
	            	<span class="label label-success">可用</span>
	            {else}
	            	<span class="label label-danger">驳回</span>
	            {/if}
            </span>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">抬头名称：</label>
            <span class="margin-left-2">{$detail['name']}</span>
        </div>
        {if $detail['name'] neq '个人'}
            <div class="form-group">
                <label class="col-sm-3 control-label">纳税人识别号：</label>
                <span class="margin-left-2">{$detail['info_1']}</span>
            </div>
        {/if}
        {if $detail['type'] eq 'special'}
        <div class="form-group">
            <label class="col-sm-3 control-label">基本开户银行名称：</label>
            <span class="margin-left-2">{$detail['info_2']}</span>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">基本开户账号：</label>
            <span class="margin-left-2">{$detail['info_3']}</span>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">注册场所地址：</label>
            <span class="margin-left-2">{$detail['info_4']}</span>
        </div>
        <div class="form-group">
            <label class="col-sm-3 control-label">注册固定电话：</label>
            <span class="margin-left-2">{$detail['info_5']}</span>
        </div>
        <div class="form-group">
            {if $detail['file_1']}
            <div class="col-sm-4 text-center">
                营业执照
                <div class="gallery">
                    <a href="{$systemurl}?m=invoiceManager&page=title&action=detail&id={$detail['id']}&img={$detail['file_1']}" style="background-image: url('{$systemurl}/?m=invoiceManager&page=title&action=detail&id={$detail['id']}&img={$detail['file_1']}')">
                    </a>
                </div>
            </div>
            {/if}
            {if $detail['file_2']}
            <div class="col-sm-4 text-center">
                税务登记证
                <div class="gallery">
                    <a href="{$systemurl}/?m=invoiceManager&page=title&action=detail&id={$detail['id']}&img={$detail['file_2']}" style="background-image: url('{$systemurl}/?m=invoiceManager&page=title&action=detail&id={$detail['id']}&img={$detail['file_2']}')">
                    </a>
                </div>
            </div>
            {/if}
            {if $detail['file_3']}
            <div class="col-sm-4 text-center">
                一般纳税人资格证
                <div class="gallery">
                    <a href="{$systemurl}/?m=invoiceManager&page=title&action=detail&id={$detail['id']}&img={$detail['file_3']}" style="background-image: url('{$systemurl}/?m=invoiceManager&page=title&action=detail&id={$detail['id']}&img={$detail['file_3']}')">
                    </a>
                </div>
            </div>
            {/if}
        </div>
        {/if}
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