{$notice}

<div class="alert alert-warning clearfix">
    <div class="pull-left">
        <h4>温馨提示</h4>
        <p>1. 后付费月结算单的可开票金额为当月实际结算金额。</p>
        <p>2. 本月产生的后付费业务月结算单在下个月二号以后才可以索取发票。</p>
        <p>3. 发票基于订单、月结算单开具（单个订单、月结算单不可拆分开票）。</p>
        <p>4. 单张发票金额限额100万，索取金额超过100万将拆分成多张发票开具。</p>
    </div>
</div>

    <div class="panel panel-default panel-table">
        <div class="panel-heading">
            <h3 class="panel-title">账单列表</h3>
        </div>
        <form action="{$systemurl}?m=invoiceManager&page=invoice&action=info" method="POST">
            <input type="hidden" id="amount" name="amount" value="" />
            <div class="panel-body" style="padding: 0;">
                <div class="invoice-info total">
                    <div class="pull-left">
                        您选取了 <span class="num">0</span> 条单据开具发票，
                        已选总金额：<span class="number">0.00</span>
                    </div>
                    <div class="pull-right">
                        <button type="submit" class="getinvoice btn btn-success btn-sm disabled">索取发票</button>
                    </div>
                </div>
                <table id="tableInvoicePlusList" class="table table-list no-footer dtr-inline">
                    <thead>
                    <tr role="row">
                        <th width="10" class="text-center"><input type="checkbox" onclick="CheckAll(this)" /></th>
                        <th>账单编号</th>
                        <th>产品名称</th>
                        <th>消费金额</th>
                        <th>支付方式</th>
                        <th>支付日期</th>
                    </tr>
                    </thead>
                    {if $invoices}
                        <tbody>
                        {foreach $invoices as $value}
                            <tr class="odd" role="row">
                                <td class="text-center"><input type="checkbox" name="invoice[]" value="{$value['id']}" data-price="{$value['amount']}" /></td>
                                <td>{$value['id']}</td>
                                <td>{$value['name']}</td>
                                <td class="price">{$value['amount']}</td>
                                <td>{$value['payment']}</td>
                                <td class="sorting_1">{$value['date']}</td>
                            </tr>
                        {/foreach}
                        </tbody>
                    {/if}
                </table>
            </div>
        </form>
        {if !$invoices}
            <div class="none-data text-center">
                <div class="no-data-info">
                    <i class="fa fa-exclamation-triangle"></i> {$message}
                </div>
            </div>
        {/if}
    </div>