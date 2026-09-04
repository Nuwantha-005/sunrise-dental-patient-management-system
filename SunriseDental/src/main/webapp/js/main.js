document.addEventListener('DOMContentLoaded', function() {
    // Toggle password visibility on login
    var toggleBtn = document.getElementById('togglePassword');
    var pwdInput = document.getElementById('password');
    if (toggleBtn && pwdInput) {
        toggleBtn.addEventListener('click', function() {
            var type = pwdInput.getAttribute('type') === 'password' ? 'text' : 'password';
            pwdInput.setAttribute('type', type);
            toggleBtn.textContent = type === 'password' ? 'Show' : 'Hide';
        });
    }

    // Auto-dismiss success messages
    var successAlert = document.querySelector('.alert-success.auto-dismiss');
    if (successAlert) {
        setTimeout(function() { successAlert.style.display = 'none'; }, 4000);
    }

    // Add bill item row
    var addItemBtn = document.getElementById('addBillItem');
    if (addItemBtn) {
        addItemBtn.addEventListener('click', function() {
            var tbody = document.getElementById('billItemsBody');
            var row = document.createElement('tr');
            row.innerHTML = '<td><input type="text" name="description" class="form-control-inline" placeholder="Description"></td>'
                + '<td><input type="number" name="amount" class="form-control-inline" step="0.01" min="0" placeholder="0.00" onchange="calculateTotal()"></td>'
                + '<td><button type="button" class="btn btn-sm btn-danger" onclick="this.closest(\'tr\').remove(); calculateTotal();">X</button></td>';
            tbody.appendChild(row);
        });
    }
});

function calculateTotal() {
    var amounts = document.querySelectorAll('input[name="amount"]');
    var total = 0;
    amounts.forEach(function(input) {
        var val = parseFloat(input.value);
        if (!isNaN(val)) total += val;
    });
    var totalEl = document.getElementById('billTotal');
    if (totalEl) {
        totalEl.textContent = 'Rs. ' + total.toFixed(2);
    }
}

function confirmDelete(message) {
    return confirm(message || 'Are you sure you want to delete this record?');
}

function printReceipt() {
    window.print();
}
