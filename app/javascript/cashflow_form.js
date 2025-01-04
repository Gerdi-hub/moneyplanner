document.addEventListener("turbo:load", () => {
    const amountField = document.getElementById("amount-field");
    const creditDebitField = document.getElementById("credit-debit-field");

    if (amountField && creditDebitField) {
        amountField.addEventListener("input", () => {
            const amount = parseFloat(amountField.value);

            if (!isNaN(amount)) {
                creditDebitField.value = amount < 0 ? "credit" : "debit";
            }
        });
    }
});