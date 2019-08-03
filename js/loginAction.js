
document.querySelectorAll('#email')
    .forEach(
        function (field, index, arr) {
            field.value = '%username%';
            field.dispatchEvent(new Event('input'));
        }
    );

document.querySelectorAll('#pass')
    .forEach(
        function (field, index, arr) {
            field.value = '%password%';
            field.dispatchEvent(new Event('input'));
        }
    );

document.getElementById('send2').click();   

