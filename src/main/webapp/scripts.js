document.addEventListener('DOMContentLoaded', function () {
    const tabs = document.querySelectorAll('nav ul li a');
    const contents = document.querySelectorAll('.tab-content');
    const transactionHistoryContainer = document.getElementById('transactionHistory');
    let transactionHistory = [];

    tabs.forEach(tab => {
        tab.addEventListener('click', function (event) {
            event.preventDefault();

            contents.forEach(content => content.style.display = 'none');
            tabs.forEach(tab => tab.classList.remove('active'));

            const target = document.querySelector(tab.getAttribute('href'));
            target.style.display = 'block';
            tab.classList.add('active');
        });
    });

    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');
    const toggleLink = document.getElementById('toggleLink');

    toggleLink.addEventListener('click', function (event) {
        event.preventDefault();
        if (loginForm.style.display === 'none') {
            loginForm.style.display = 'block';
            registerForm.style.display = 'none';
            toggleLink.textContent = 'Немає облікового запису?';
        } else {
            loginForm.style.display = 'none';
            registerForm.style.display = 'block';
            toggleLink.textContent = 'Вже маєте обліковий запис?';
        }
    });

    loginForm.addEventListener('submit', function (event) {
        event.preventDefault();
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        if (username === 'admin' && password === 'password') {
            alert('Успішний вхід!');
        } else {
            alert('Невірний логін або пароль!');
        }
    });

    registerForm.addEventListener('submit', function (event) {
        event.preventDefault();
        const newUsername = document.getElementById('newUsername').value;
        const newPassword = document.getElementById('newPassword').value;

        // Тут ви можете додати код для обробки реєстрації нового користувача
        alert(`Користувач ${newUsername} успішно зареєстрований!`);
    });

    const activeLoansContainer = document.getElementById('activeLoans');

    document.getElementById('loanForm').addEventListener('submit', function (event) {
        event.preventDefault();
        const loanAmount = parseFloat(document.getElementById('loanAmount').value);
        const loanTerm = parseInt(document.getElementById('loanTerm').value);
        const interestRate = parseFloat(document.getElementById('interestRate').value);

        const totalInterest = loanAmount * (interestRate / 100) * (loanTerm / 12);
        const totalRepayment = loanAmount + totalInterest;

        const loanDetails = `
            Сума Кредиту: $${loanAmount.toFixed(2)}<br>
            Термін: ${loanTerm} місяців<br>
            Відсоткова ставка: ${interestRate}%<br>
            Загальна сума виплати: $${totalRepayment.toFixed(2)}<br>
        `;

        document.getElementById('loanDetails').innerHTML = loanDetails;
        document.getElementById('loanSummary').style.display = 'block';

        const newLoan = document.createElement('div');
        newLoan.classList.add('card');
        newLoan.innerHTML = `
            <h3>Кредит на $${loanAmount.toFixed(2)}</h3>
            <p>Термін: ${loanTerm} місяців</p>
            <p>Відсоткова ставка: ${interestRate}%</p>
            <p>Загальна сума виплати: $${totalRepayment.toFixed(2)}</p>
        `;

        activeLoansContainer.appendChild(newLoan);
    });

    document.getElementById('transactionForm').addEventListener('submit', function (event) {
        event.preventDefault();
        const recipientId = document.getElementById('recipientId').value;
        const transferAmount = parseFloat(document.getElementById('transferAmount').value);
        const currentBalance = parseFloat(document.getElementById('accountBalance').textContent);

        if (transferAmount > currentBalance) {
            alert('Недостатньо коштів для переказу!');
        } else {
            const newBalance = currentBalance - transferAmount;
            document.getElementById('accountBalance').textContent = newBalance.toFixed(2);

            const transactionDetails = `
                Переказано: $${transferAmount.toFixed(2)}<br>
                Отримувач ID: ${recipientId}<br>
                Залишок на рахунку: $${newBalance.toFixed(2)}<br>
            `;

            document.getElementById('transactionDetails').innerHTML = transactionDetails;
            document.getElementById('transactionSummary').style.display = 'block';

            const transaction = {
                recipientId,
                transferAmount: transferAmount.toFixed(2),
                newBalance: newBalance.toFixed(2),
                date: new Date().toLocaleString()
            };

            transactionHistory.push(transaction);
            updateTransactionHistory();
            alert('Транзакція успішно виконана!');
        }
    });

    function updateTransactionHistory() {
        transactionHistoryContainer.innerHTML = '';
        if (transactionHistory.length === 0) {
            transactionHistoryContainer.innerHTML = '<p>Історія транзакцій порожня.</p>';
        } else {
            transactionHistory.forEach(transaction => {
                const transactionElement = document.createElement('div');
                transactionElement.classList.add('transaction');
                transactionElement.innerHTML = `
                    <p>Переказано: $${transaction.transferAmount}</p>
                    <p>Отримувач ID: ${transaction.recipientId}</p>
                    <p>Залишок на рахунку: $${transaction.newBalance}</p>
                    <p>Дата: ${transaction.date}</p>
                `;
                transactionHistoryContainer.appendChild(transactionElement);
            });
        }
    }
});




