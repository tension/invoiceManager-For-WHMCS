<link rel="stylesheet" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/style.css">
<link rel="stylesheet" type="text/css" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/sweetalert.css" />
<script type="text/javascript" src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/sweetalert.min.js"></script>
<script type="text/javascript">
    $(function(){
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

        $("input[name='invoice[]']:checkbox").click(function(){
            clickinvoice();
        });

    });

    function CheckAll(obj){
        $("#tableInvoicePlusList input[type='checkbox']").prop('checked', $(obj).prop('checked'));
        clickinvoice();
    }

    function clickinvoice() {
        var sum=0;
        var count=0;
        var checked = $("input[name='invoice[]']:checkbox:checked");
        var length = checked.length;
        checked.each(function(){
            sum+= parseInt($(this).data('price'));
        });

        if (length == 0) {
            $(".getinvoice").addClass('disabled');
        } else {
            $(".getinvoice").removeClass('disabled');
        }

        checked.each(function(){
            sum= parseFloat($(this).data('price'));
            if(sum != NaN && $.trim(sum) != "" && sum != null && !isNaN(sum))
                count += sum;
        });

        $(".total .num").text(length);
        $(".total .number").text(Number(count).toFixed(2));
        $("#amount").val(Number(count).toFixed(2));
    }
</script>

<div class="row">
    <div class="col-sm-3">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-sliders"></i> {$pagetitle}</h3>
            </div>
            <div class="list-group">
                <a href="{$WEB_ROOT}/?m=invoiceManager" class="list-group-item{if $pageName eq 'default' || !$pageName} active{/if}">
                    <i class="fa fa-check-square fa-fw"></i> 申请发票
                </a>
                <a href="{$WEB_ROOT}/?m=invoiceManager&page=invoice" class="list-group-item{if $pageName eq 'invoice' || $pageName eq 'invoice.detail' || $pageName eq 'invoice.info'} active{/if}">
                    <i class="fa fa-list fa-fw"></i> 发票列表
                </a>
                <a href="{$WEB_ROOT}/?m=invoiceManager&page=express" class="list-group-item{if $pageName eq 'express' || $pageName eq 'express.detail'} active{/if}">
                    <i class="fa fa-plane fa-fw"></i> 快递列表
                </a>
                <a href="{$WEB_ROOT}/?m=invoiceManager&page=title" class="list-group-item{if $pageName eq 'title' || $pageName eq 'title.detail' || $pageName eq 'title.editor'} active{/if}">
                    <i class="fa fa-briefcase fa-fw"></i> 抬头管理
                </a>
                <a href="{$WEB_ROOT}/?m=invoiceManager&page=address" class="list-group-item{if $pageName eq 'address' || $pageName eq 'address.detail' || $pageName eq 'address.editor'} active{/if}">
                    <i class="fa fa-user fa-fw"></i> 地址管理
                </a>
            </div>
        </div>
    </div>

    <div class="col-sm-9">
        {if $pageName eq 'tips/warning' ||  $pageName eq 'tips/success' ||  $pageName eq 'tips/danger' ||  $pageName eq 'tips/info'}
            {include file="../$pageName.tpl"}
        {else}
            {include file="./$pageName.tpl"}
        {/if}
    </div>
</div>