

<div class="title">
	Payment Schemes
	<span class="right">
		+
		<a href="/admin/paymentscheme">Add a payment scheme</a>
	</span>
</div>

<table class="tablelist">
%for s in vd['schemes']:

	<tr class="row">
		<td class="col1">{{s.name}}</td>
		<td class="col2">
			<a href="/admin/paymentscheme/{{s._id}}/delete">Delete</a>
		</td>
	</tr>
	
%end
</table>

%rebase base_admin vd=vd