

var field = document.getElementById('coupon_code');
if (field != null){
    console.log('encontrou o field');
    field.value = '%coupon_code%';
    field.dispatchEvent(new Event('input'));
    
}else{
    console.log('nao encontrou field');
}
