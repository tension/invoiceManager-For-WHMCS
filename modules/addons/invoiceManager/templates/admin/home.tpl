<link rel="stylesheet" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/style.css">
<link rel="stylesheet" type="text/css" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/sweetalert.css" />
<script type="text/javascript" src="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/sweetalert.min.js"></script>
<ul class="nav nav-tabs admin-tabs" role="tablist" style="margin-bottom: 10px;">
    <li{if $pageName eq 'default' || $pageName eq 'invoice.detail'} class="active"{/if}><a href="{$modulelinks}">开票列表</a></li>
    <li{if $pageName eq 'title' || $pageName eq 'title.detail'} class="active"{/if}><a href="{$modulelinks}&page=title">抬头列表</a></li>
    <li{if $pageName eq 'express.list' || $pageName eq 'express.detail'} class="active"{/if}><a href="{$modulelinks}&page=express&action=list">快递列表</a></li>
    <li{if $pageName eq 'express.manager' || $pageName eq 'express.price'} class="active"{/if}><a href="{$modulelinks}&page=express_manager">快递管理</a></li>
    <li{if $pageName eq 'invoice.search'} class="active"{/if}><a href="{$modulelinks}&page=invoice_search">发票搜索</a></li>
    <li{if $pageName eq 'express.search'} class="active"{/if}><a href="{$modulelinks}&page=express_search">快递搜索</a></li>
    <li class="pull-right{if $pageName eq 'express'} active{/if}"><a href="{$modulelinks}&page=express">发快递</a></li>
    <li class="pull-right{if $pageName eq 'invoice'} active{/if}"><a href="{$modulelinks}&page=invoice">开发票</a></li>
</ul>

{if $pageName eq 'tips/warning' ||  $pageName eq 'tips/success' ||  $pageName eq 'tips/danger' ||  $pageName eq 'tips/info'}
    {include file="../$pageName.tpl"}
{else}
    {include file="./$pageName.tpl"}
{/if}