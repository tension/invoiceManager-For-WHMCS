{$notice}

<form action="{$modulelinks}&page=express_manager&action=price&id={$id}" method="post">
    <input type="hidden" name="id" value="{$id}" />
<div class="tablebg">
    <table id="sortabletbl0" class="datatable" width="100%" border="0" cellspacing="1" cellpadding="3">
        <tr>
            <th width="60">排序</th>
            <th>地区</th>
            <th width="80">金额</th>
            <th width="100">状态</th>
            <th width="60">操作</th>
        </tr>
        {if $price}
            {foreach $price as $value}
                <tr>
                    <td><input class="form-control input-sm" name="price[{$value['id']}][orderby]" type="text" value="{$value['orderby']}" /></td>
                    <td><input class="form-control input-sm" name="price[{$value['id']}][province]" type="text" value="{$value['province']}" /></td>
                    <td><input class="form-control input-sm" name="price[{$value['id']}][price]" type="text" value="{$value['price']}" /></td>
                    <td>
                        <select name="price[{$value['id']}][status]" class="form-control input-sm">
                            <option value="success">启用</option>
                            <option value="danger">禁用</option>
                        </select>
                    </td>
                    <td class="text-right">
                        <a href="javascript:swal({
  title: '删除确认',
  text: '你确定删除这个区域的价格设置吗？',
  type: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#DD6B55',
  confirmButtonText: '确定',
  cancelButtonText: '取消',
  closeOnConfirm: false
},
function(){
	location='{$modulelinks}&page=express_manager&action=price&id={$id}&delete={$value['id']}'
});" class="btn btn-sm btn-danger">删除</a>
                    </td>
                </tr>
            {/foreach}
        {/if}
        <tr>
            <td><input class="form-control input-sm" name="price[0][orderby]" type="text" value="" /></td>
            <td><input class="form-control input-sm" name="price[0][province]" type="text" value="" /></td>
            <td><input class="form-control input-sm" name="price[0][price]" type="text" value="" /></td>
            <td>
                <select name="price[0][status]" class="form-control input-sm">
                    <option>启用</option>
                    <option>未启用</option>
                </select>
            </td>
            <td class="text-right">
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