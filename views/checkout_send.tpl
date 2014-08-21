<html>
<head></head>
<body>
	<form action="https://www.paypal.com/cgi-bin/webscr" method="post">
		<input type="hidden" name="cmd" value="_cart">
		<input type="hidden" name="upload" value="1">
		<input type="hidden" name="business" value="markphotographer22@googlemail.com">
		<input type="hidden" name="currency_code" value="GBP">

		%for item in items:
			<input type="hidden" name="item_name_{{item['counter']}}" value="{{item['name']}}">
			<input type="hidden" name="amount_{{item['counter']}}" value="{{item['cost']}}">
			<input type="hidden" name="quantity_{{item['counter']}}" value="{{item['quantity']}}">
		%end
	</form>
	<script type="text/javascript">
	document.getElementsByTagName('form')[0].submit();
	</script>
</body>
</html>