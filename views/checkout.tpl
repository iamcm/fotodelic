	

<div class="container">
	<h4>Checkout</h4>
	<nr />
	<form class="form" method="post" action="/checkout-send" id="checkout-form">
		%for item in vd['basket']:
		<div class="row basket-orderline-row" data-cost="{{item['price']}}">
			<div class="col-sm-1"><span class="glyphicon glyphicon-remove" data-return="{{vd['url']}}" data-id="{{item['id']}}"></span></div>
			<div class="col-sm-8">{{item['name']}}</div>
			<div class="col-sm-2">£{{item['price']}} each</div>
			<div class="col-sm-1">
				<select name="quantity_{{item['id']}}" class="right">
					<option>1</option>
					<option>2</option>
					<option>3</option>
					<option>4</option>
					<option>5</option>
					<option>6</option>
					<option>7</option>
					<option>8</option>
					<option>9</option>
					<option>10</option>
				</select>
			</div>
		</div>
		%end
		<div class="row basket-orderline-row">
			<div class="col-sm-12">
				<div class="right bold">Total: £<span id="basket-total"></span></div>
			</div>
		</div>
		<div class="basket-orderline-row">
			<div class="alert alert-info" role="alert">Please take care to enter your email address correctly as this is the address that the full quality print will be emailed to.</div>
			<div class="col-sm-6">
				<div class="form-group">
					<div class="input-group" style="width:100%">
						<input class="form-control" type="email" id="email" name="email" placeholder="Email address">
					</div>
				</div>
			</div>
			<div class="clearfix"></div>
		</div>
		<div class="row basket-orderline-row">
			<div class="col-sm-12">
				<div class="right">
					<input type="submit" class="btn btn-primary" value="Proceed to PayPal" />
				</div>
			</div>
		</div>
	</form>
</div>

%def js():
<script type="text/javascript">
	
	function remove_item(returnTo, id){
		html = '<form id="remove-item-form" method="post" action="/basket/remove">';
		html += '    <input type="hidden" name="returnTo" value="'+returnTo+'">';
		html += '    <input type="hidden" name="id" value="'+id+'">';
		html += '</form>';

		$('body').append(html);
		$('#remove-item-form').submit();
	}

	function calculate_basket_total(){
		var total = 0.00;
		$('.basket-orderline-row').each(function(){
			if($(this).data('cost') != undefined){
				total += parseFloat($(this).data('cost')) * parseFloat($(this).find('select').val());				
			}
		})

		if(typeof(total) != 'undefined' && !isNaN(parseFloat(total))) {
			$('#basket-total').text(total.toFixed(2));			
		}
	}

	$(document).ready(function(){
		calculate_basket_total();

		$('.basket-orderline-row select').on('change', function(){
			calculate_basket_total();
		})

		$('.glyphicon-remove').on('click', function(){
			remove_item($(this).data('return'), $(this).data('id'));
		})

		$('#checkout-form').on('submit', function(ev){
			if($('#email').val() == ''){
				$('#email').closest('.form-group').addClass('has-warning');
				alert('Please enter an email address so we can send you the full quality print(s) after your completed payment');
				ev.preventDefault();
			}
		});
	})

</script>
%end

%rebase base_public vd=vd, bodyclass='checkout', js=js
