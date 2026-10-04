// SupplierConnect Dashboard JS Helpers

document.addEventListener('DOMContentLoaded', function () {
    console.log('SupplierConnect main script initialized.');

    // Initialize Tooltips if Bootstrap is present
    if (typeof bootstrap !== 'undefined') {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }

    // Dynamic Order Item Calculation Logic
    const orderItemsContainer = document.getElementById('order-items-container');
    const addItemBtn = document.getElementById('add-item-btn');
    const grandTotalSpan = document.getElementById('grand-total');

    if (orderItemsContainer && addItemBtn) {
        addItemBtn.addEventListener('click', function () {
            const template = document.getElementById('order-item-template');
            if (template) {
                const clone = template.content.cloneNode(true);
                orderItemsContainer.appendChild(clone);
                recalculateOrderTotals();
            }
        });

        orderItemsContainer.addEventListener('change', function (e) {
            if (e.target.classList.contains('product-select')) {
                const row = e.target.closest('.order-item-row');
                const selectedOption = e.target.options[e.target.selectedIndex];
                const price = parseFloat(selectedOption.getAttribute('data-price') || 0);
                const priceInput = row.querySelector('.unit-price-input');
                if (priceInput) {
                    priceInput.value = price.toFixed(2);
                }
                recalculateRow(row);
            }
        });

        orderItemsContainer.addEventListener('input', function (e) {
            if (e.target.classList.contains('qty-input')) {
                const row = e.target.closest('.order-item-row');
                recalculateRow(row);
            }
        });

        orderItemsContainer.addEventListener('click', function (e) {
            if (e.target.closest('.remove-item-btn')) {
                const row = e.target.closest('.order-item-row');
                if (document.querySelectorAll('.order-item-row').length > 1) {
                    row.remove();
                    recalculateOrderTotals();
                } else {
                    alert('An order must have at least one product item.');
                }
            }
        });
    }

    function recalculateRow(row) {
        const priceInput = row.querySelector('.unit-price-input');
        const qtyInput = row.querySelector('.qty-input');
        const subtotalSpan = row.querySelector('.item-subtotal');

        const price = parseFloat(priceInput ? priceInput.value : 0) || 0;
        const qty = parseInt(qtyInput ? qtyInput.value : 0) || 0;
        const subtotal = price * qty;

        if (subtotalSpan) {
            subtotalSpan.textContent = '$' + subtotal.toFixed(2);
        }
        recalculateOrderTotals();
    }

    function recalculateOrderTotals() {
        let total = 0;
        document.querySelectorAll('.order-item-row').forEach(row => {
            const priceInput = row.querySelector('.unit-price-input');
            const qtyInput = row.querySelector('.qty-input');
            const price = parseFloat(priceInput ? priceInput.value : 0) || 0;
            const qty = parseInt(qtyInput ? qtyInput.value : 0) || 0;
            total += (price * qty);
        });

        if (grandTotalSpan) {
            grandTotalSpan.textContent = '$' + total.toFixed(2);
        }
    }
});
