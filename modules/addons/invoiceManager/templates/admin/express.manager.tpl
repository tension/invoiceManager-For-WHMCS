{$notice}

<form action="{$modulelinks}&page=express_manager" method="post">
<div class="tablebg">
    <table id="sortabletbl0" class="datatable" width="100%" border="0" cellspacing="1" cellpadding="3">
        <tr>
            <th>快递名称</th>
            <th>快递简称</th>
            <th>默认价格</th>
            <th>状态</th>
            <th width="105">操作</th>
        </tr>
        {if $express}
            {foreach $express as $value}
                <tr>
                    <td>
                        <input class="form-control input-sm" name="express[{$value['id']}][name]" type="text" value="{$value['name']}" />
                    </td>
                    <td>
                        <input class="form-control input-sm" name="express[{$value['id']}][code]" type="text" value="{$value['code']}" />
                    </td>
                    <td>
                        <input class="form-control input-sm" name="express[{$value['id']}][price]" type="text" value="{$value['price']}" />
                    </td>
                    <td>
                        <select name="express[{$value['id']}][status]" class="form-control input-sm">
                            <option value="success" {if $value['status'] eq 'success'}selected{/if}>启用</option>
                            <option value="danger" {if $value['status'] eq 'danger'}selected{/if}>禁用</option>
                        </select>
                    </td>
                    <td class="text-right">
                        <a href="{$modulelinks}&page=express_manager&action=price&id={$value['id']}" class="btn btn-sm btn-primary">设置</a>
                        <a href="javascript:swal({
  title: '删除确认',
  text: '你确定删除这一条快递记录吗？',
  type: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#DD6B55',
  confirmButtonText: '确定',
  cancelButtonText: '取消',
  closeOnConfirm: false
},
function(){
	location='{$modulelinks}&page=express_manager&action=delete&id={$value['id']}'
});" class="btn btn-sm btn-danger">删除</a>
                    </td>
                </tr>
            {/foreach}
        {/if}
        <tr>
            <td><input class="form-control input-sm" name="express[0][name]" type="text" value="" /></td>
            <td><input class="form-control input-sm" name="express[0][code]" type="text" value="" /></td>
            <td><input class="form-control input-sm" name="express[0][price]" type="text" value="" /></td>
            <td>
                <select name="express[0][status]" class="form-control input-sm">
                    <option value="success">启用</option>
                    <option value="danger">禁用</option>
                </select>
            </td>
            <td class="text-right">
                <a href="#" class="btn btn-sm btn-primary disabled">设置</a>
                <a href="#" class="btn btn-sm btn-danger disabled">删除</a>
            </td>
        </tr>
        <tr>
            <td colspan="5" class="text-right">
                <button type="submit" class="btn btn-sm btn-primary">保存</>
            </td>
        </tr>
    </table>
</div>
</form>