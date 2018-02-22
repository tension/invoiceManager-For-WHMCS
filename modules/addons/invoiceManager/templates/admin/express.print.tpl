<style media="print"> 
.noPrint {
	display: none;
} 
</style>
<script language="javascript" type="text/javascript">  
    function printHTML(){  
        var bdhtml = window.document.body.innerHTML;//获取当前页的html代码    
        var sprnstr = "<!--startprint-->";   
        var eprnstr = "<!--endprint-->";    
        var prnhtml=bdhtml.substring(bdhtml.indexOf(sprnstr)); //从开始代码向后取html    
        var prnhtml=prnhtml.substring(0,prnhtml.indexOf(eprnstr));//从结束代码向前取html    
        window.document.body.innerHTML=prnhtml;    
        window.print();    
        window.document.body.innerHTML=bdhtml;    
    }  
</script>  
<link rel="stylesheet" type="text/css" href="{$WEB_ROOT}/modules/addons/invoiceManager/templates/stylesheets/print/{$info['expressCode']}.css" />
<!--startprint-->
<div class="print">
	<div class="infoName">
		<span>项目名称：</span>
		{$info['name']}
	</div>
	<div class="infoAddrName">
		<span>收件人名：</span>
		{$info['address']['name']}
	</div>
	<div class="infoAddress">
		<span>收件地址：</span>
		{$info['address']['province']}{$info['address']['address']}
	</div>
	<div class="infoMobile">
		<span>收件电话：</span>
		{$info['address']['mobile']}{if $info['address']['phone']}, {$info['address']['phone']}{/if}
	</div>
	<div class="infoTime">
		{$info['timestamp']|date_format:'Y-m-d'}
	</div>
	
	<div class="sendName">
		<span>发件人名：</span>
		{$send['name']}
	</div>
	<div class="sendCompany">
		<span>发件公司：</span>
		{$send['company']}
	</div>
	<div class="sendAddr">
		<span>发件地址：</span>
		{$send['address']}
	</div>
	<div class="sendPhone">
		<span>发件电话：</span>
		{$send['phone']}
	</div>
</div>
<!--endprint-->
<div class="noPrint" style="margin-top: 20px;"> 
	<input style="
	color: #FFF;
	display: inline-block;
    padding: 4px 12px;
    margin-bottom: 0;
    font-size: 14px;
    font-weight: 400;
    line-height: 1.42857143;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    -ms-touch-action: manipulation;
    touch-action: manipulation;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    background-color: #5cb85c;
    border: 1px solid #5cb85c;
    border-radius: 4px;" onClick="printHTML()" type="button" value="打印" />
</div>