<link rel="stylesheet" type="text/css" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/Dropify/css/dropify.min.css" />
<script type="text/javascript" src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/Dropify/js/dropify.min.js"></script>
<script type="text/javascript">
    $(function(){
	    var titletype = $('[name=titletype]:checked').val();
	    if ( titletype == 'personal') {
            $('#special').attr('disabled',true).parent().parent().addClass('disabled');
	    } 
        $(".addInvoice-info > div").click(function () {
            $(this).addClass("selected").find('input[type=radio]').attr("checked", "checked");
            $(this).siblings().removeClass("selected").find('input[type=radio]').removeAttr("checked");
        });
        $(".addInvoice-addr > div").click(function () {
            $(this).addClass("selected").find('input[type=radio]').attr("checked", "checked");
            $(this).siblings().removeClass("selected").find('input[type=radio]').removeAttr("checked");
        });
        $('#Enterprise').click(function(){
            $('.company').show();
            $('#special').attr('disabled',false).parent().parent().removeClass('disabled');
        });
        $('#Personal').click(function(){
            var checked = !!$('#ordinary').prop('checked');
            $('.company').hide();
            $('.special-viewer').hide();
            $('#ordinary').prop('checked', !checked);
            $('#special').attr('disabled',true).parent().parent().addClass('disabled');
        });
        $('#special').click(function(){
            $('.special-viewer').show();
        });
        $('#ordinary').click(function(){
            $('.special-viewer').hide();
        });
		$('.dropify').dropify({
		    messages: {
		        'default': '拖放一个文件或者点击这里',
		        'replace': '拖拽或单击替换',
		        'remove':  '移除',
		        'error': {
			        'fileSize': '上传的文件不能超过 ({ { value } }！).'
			    }
		    }
		});
    });
</script>

<div class="panel panel-default">
    <div class="panel-heading">
        <h3 class="panel-title">编辑抬头</h3>
    </div>
    <div class="panel-body">
        <form class="form-horizontal" id="info" action="{$systemurl}?m=invoiceManager&page=title" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="{$id}" />
            <div class="form-group">
                <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 开具类型</label>
                <div class="col-sm-8">
                    <div class="radio-inline">
                        <label>
                            <input type="radio" name="titletype" id="Personal" value="personal" {if $detail['name'] eq '个人' || !$id}checked{/if}> 个人
                        </label>
                    </div>
                    <div class="radio-inline">
                        <label>
                            <input type="radio" name="titletype" id="Enterprise" value="enterprise"{if $detail['name'] neq '个人' && $id}checked{/if}> 企业
                        </label>
                    </div>
                </div>
            </div>
            <div class="company" {if $detail['name'] neq '个人' && $id}style="display: block"{/if}>
	            <div class="form-group">
	                <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 发票抬头</label>
	                <div class="col-sm-8">
	                    <input type="text" name="invoicetitle" class="form-control" placeholder="请填写您营业执照上的全称" value="{$detail['name']}">
	                </div>
	            </div>
	            <div class="form-group">
	                <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 纳税人识别号</label>
	                <div class="col-sm-8">
	                    <input type="text" name="info_1" class="form-control" placeholder="请填写您的纳税人识别号" value="{$detail['info_1']}">
	                    <span>请与贵公司财务人员核实并填写准确的纳税人识别号，以免影响您发票后续的使用</span>
	                </div>
	            </div>
            </div>
            <div class="form-group leixing none">
                <label class="col-sm-3 control-label">发票类型</label>
                <div class="col-sm-8">
                    <div class="radio-inline">
                        <label>
                            <input type="radio" name="invoicetype" id="ordinary" value="standard" {if $detail['type'] eq 'standard'}checked{/if}> 增值税普通发票
                        </label>
                    </div>
                    <div class="radio-inline">
                        <label>
                            <input type="radio" name="invoicetype" id="special" value="special" {if $detail['type'] eq 'special'}checked{/if}> 增值税专用发票
                        </label>
                    </div>
                </div>
            </div>
            <div class="special-viewer" {if $detail['type'] eq 'special'}style="display: block"{/if}>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 基本开户银行名称</label>
                    <div class="col-sm-8">
                        <input type="text" name="info_2" class="form-control" placeholder="请填写您开户许可证上的开户银行" value="{$detail['info_2']}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 基本开户账号</label>
                    <div class="col-sm-8">
                        <input type="text" name="info_3" class="form-control" placeholder="请填写您开户许可证上的银行账号" value="{$detail['info_3']}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 注册场所地址</label>
                    <div class="col-sm-8">
                        <input type="text" name="info_4" class="form-control" placeholder="请填写您营业执照上的注册地址" value="{$detail['info_4']}">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label"><i class="fa fa-asterisk"></i> 注册固定电话</label>
                    <div class="col-sm-8">
                        <input type="text" name="info_5" class="form-control" placeholder="请填写您公司有效的联系电话" value="{$detail['info_5']}">
                    </div>
                </div>
                <div class="form-group">
	                <div class="col-sm-10 col-sm-offset-1">
		                <div class="alert alert-warning" style="margin-bottom: 0;">
		                    <strong>注意事项</strong>
		                    仅允许上传大小不超过 {$fileSize} KB 且文件后缀为 {$extsName} 的图像
		                </div>
	                </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">
                    	<i class="fa fa-asterisk"></i> 营业执照
                    </label>
                    <div class="col-sm-4">
	                    <input type="file" name="file_1" class="dropify" data-height="120" data-max-file-size="{$fileSize}KB" data-allowed-file-extensions="{$extsName}" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">
                    	税务登记证
                    </label>
                    <div class="col-sm-4">
	                    <input type="file" name="file_2" class="dropify" data-height="120" data-max-file-size="{$fileSize}KB" data-allowed-file-extensions="{$extsName}" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-3 control-label">
                    	<i class="fa fa-asterisk"></i> 一般纳税人资格证
                    </label>
                    <div class="col-sm-4">
	                    <input type="file" name="file_3" class="dropify" data-height="120" data-max-file-size="{$fileSize}KB" data-allowed-file-extensions="{$extsName}" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-5 col-sm-offset-3">
                    <button type="submit" class="btn btn-primary">保存修改</button>
                </div>
            </div>
        </form>
    </div>
</div>