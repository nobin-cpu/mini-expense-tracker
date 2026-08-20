class AppStrings {
  const AppStrings._();

  static const String appName = 'Mini Expense Tracker';

  static const String login = 'Log in';
  static const String register = 'Create account';
  static const String logout = 'Log out';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm password';
  static const String fullName = 'Full name';
  static const String welcomeBack = 'Welcome back';
  static const String loginSubtitle = 'Log in to keep track of your spending.';
  static const String registerSubtitle =
      'Start tracking your expenses in seconds.';
  static const String noAccount = "Don't have an account?";
  static const String haveAccount = 'Already have an account?';
  static const String signUp = 'Sign up';
  static const String signIn = 'Sign in';

  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String shortPassword = 'Password must be at least 6 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String invalidAmount = 'Enter an amount greater than 0';
  static const String nameTooShort = 'Enter at least 2 characters';

  static const String home = 'Home';
  static const String totalSpent = 'Total spent';
  static const String thisMonth = 'This month';
  static const String recentExpenses = 'Recent expenses';
  static const String seeAll = 'See all';
  static const String addExpense = 'Add expense';
  static const String spendingByCategory = 'Spending by category';

  static const String expenses = 'Expenses';
  static const String editExpense = 'Edit expense';
  static const String amount = 'Amount';
  static const String category = 'Category';
  static const String date = 'Date';
  static const String note = 'Note';
  static const String noteOptional = 'Note (optional)';
  static const String noteHint = 'What was this for?';
  static const String save = 'Save';
  static const String saveChanges = 'Save changes';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String deleteExpense = 'Delete expense?';
  static const String deleteExpenseMessage =
      'This expense will be permanently removed. This cannot be undone.';
  static const String searchHint = 'Search by note or category';
  static const String allCategories = 'All';
  static const String filterCategory = 'Filter by category';

  static const String profile = 'Profile';
  static const String accountInformation = 'Account information';
  static const String name = 'Name';
  static const String memberSince = 'Member since';
  static const String preferences = 'Preferences';
  static const String darkMode = 'Dark mode';
  static const String logoutConfirmTitle = 'Log out?';
  static const String logoutConfirmMessage =
      'You will need to log in again to see your expenses.';

  static const String emptyExpensesTitle = 'No expenses yet';
  static const String emptyExpensesMessage =
      'Add your first expense and it will show up here.';
  static const String emptyFilteredTitle = 'Nothing matches';
  static const String emptyFilteredMessage =
      'Try a different category or search term.';
  static const String errorTitle = 'Something went wrong';
  static const String tryAgain = 'Try again';
  static const String genericError =
      'Something went wrong. Please try again in a moment.';
  static const String networkError =
      'No internet connection. Check your network and try again.';

  static const String expenseAdded = 'Expense added';
  static const String expenseUpdated = 'Expense updated';
  static const String expenseDeleted = 'Expense deleted';

  static const String setupTitle = 'Firebase is not set up yet';
  static const String setupMessage =
      'Run the commands below to connect this app to your Firebase project, '
      'then restart it. See README.md for the full setup steps.';
}
