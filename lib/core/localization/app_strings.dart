enum AppLanguage { ru, en, ar }

class AppStrings {
  final AppLanguage language;
  const AppStrings(this.language);

  // --- Навигация ---
  String get navShop {
    switch (language) {
      case AppLanguage.ru: return 'Магазин';
      case AppLanguage.en: return 'Shop';
      case AppLanguage.ar: return 'المتجر';
    }
  }

  String get navMyBots {
    switch (language) {
      case AppLanguage.ru: return 'Мои боты';
      case AppLanguage.en: return 'My Bots';
      case AppLanguage.ar: return 'بوتاتي';
    }
  }

  String get navSettings {
    switch (language) {
      case AppLanguage.ru: return 'Настройки';
      case AppLanguage.en: return 'Settings';
      case AppLanguage.ar: return 'الإعدادات';
    }
  }

  String get navSupport {
    switch (language) {
      case AppLanguage.ru: return 'Поддержка';
      case AppLanguage.en: return 'Support';
      case AppLanguage.ar: return 'الدعم';
    }
  }

  // --- Auth ---
  String get authLogin {
    switch (language) {
      case AppLanguage.ru: return 'Войти';
      case AppLanguage.en: return 'Login';
      case AppLanguage.ar: return 'تسجيل الدخول';
    }
  }

  String get authRegistration {
    switch (language) {
      case AppLanguage.ru: return 'Регистрация';
      case AppLanguage.en: return 'Registration';
      case AppLanguage.ar: return 'إنشاء حساب';
    }
  }

  String get authEmail {
    switch (language) {
      case AppLanguage.ru: return 'Email';
      case AppLanguage.en: return 'Email';
      case AppLanguage.ar: return 'البريد الإلكتروني';
    }
  }

  String get authPassword {
    switch (language) {
      case AppLanguage.ru: return 'Пароль';
      case AppLanguage.en: return 'Password';
      case AppLanguage.ar: return 'كلمة المرور';
    }
  }

  String get authForgotPassword {
    switch (language) {
      case AppLanguage.ru: return 'Забыли пароль?';
      case AppLanguage.en: return 'Forgot password?';
      case AppLanguage.ar: return 'هل نسيت كلمة المرور؟';
    }
  }

  String get authNoAccount {
    switch (language) {
      case AppLanguage.ru: return 'Нет аккаунта? Регистрация';
      case AppLanguage.en: return 'No account? Register';
      case AppLanguage.ar: return 'ليس لديك حساب؟ سجل الآن';
    }
  }

  String get authHasAccount {
    switch (language) {
      case AppLanguage.ru: return 'Уже есть аккаунт? Войти';
      case AppLanguage.en: return 'Already have an account? Login';
      case AppLanguage.ar: return 'لديك حساب بالفعل؟ دخول';
    }
  }

  String get authGoogle {
    switch (language) {
      case AppLanguage.ru: return 'Войти через Google';
      case AppLanguage.en: return 'Sign in with Google';
      case AppLanguage.ar: return 'تسجيل الدخول عبر Google';
    }
  }

  String get authApple {
    switch (language) {
      case AppLanguage.ru: return 'Sign in with Apple';
      case AppLanguage.en: return 'Sign in with Apple';
      case AppLanguage.ar: return 'تسجيل الدخول عبر Apple';
    }
  }

  String get authFieldsRequired {
    switch (language) {
      case AppLanguage.ru: return 'Заполните все поля';
      case AppLanguage.en: return 'Fill all fields';
      case AppLanguage.ar: return 'يرجى ملء جميع الحقول';
    }
  }

  String get authCheckEmail {
    switch (language) {
      case AppLanguage.ru: return 'Проверьте почту для подтверждения';
      case AppLanguage.en: return 'Check your email for confirmation';
      case AppLanguage.ar: return 'تحقق من بريدك الإلكتروني للتأكيد';
    }
  }

  String get authError {
    switch (language) {
      case AppLanguage.ru: return 'Произошла ошибка';
      case AppLanguage.en: return 'An error occurred';
      case AppLanguage.ar: return 'حدث خطأ ما';
    }
  }

  String get authOr {
    switch (language) {
      case AppLanguage.ru: return 'или';
      case AppLanguage.en: return 'or';
      case AppLanguage.ar: return 'أو';
    }
  }

  // --- Каталог ---
  String get catDetails {
    switch (language) {
      case AppLanguage.ru: return 'Подробнее';
      case AppLanguage.en: return 'Details';
      case AppLanguage.ar: return 'المزيد';
    }
  }

  String get catDescription {
    switch (language) {
      case AppLanguage.ru: return 'Описание';
      case AppLanguage.en: return 'Description';
      case AppLanguage.ar: return 'الوصف';
    }
  }

  String get catFunctions {
    switch (language) {
      case AppLanguage.ru: return 'Функции';
      case AppLanguage.en: return 'Functions';
      case AppLanguage.ar: return 'الميزات';
    }
  }

  String get catEmpty {
    switch (language) {
      case AppLanguage.ru: return 'Список пуст';
      case AppLanguage.en: return 'List is empty';
      case AppLanguage.ar: return 'القائمة فارغة';
    }
  }

  // --- BotDetail ---
  String get botConnect {
    switch (language) {
      case AppLanguage.ru: return 'Подключить';
      case AppLanguage.en: return 'Connect';
      case AppLanguage.ar: return 'اتصال';
    }
  }

  // --- Payment ---
  String get payMonth {
    switch (language) {
      case AppLanguage.ru: return 'месяц';
      case AppLanguage.en: return 'month';
      case AppLanguage.ar: return 'شهر';
    }
  }

  String get payYear {
    switch (language) {
      case AppLanguage.ru: return 'год';
      case AppLanguage.en: return 'year';
      case AppLanguage.ar: return 'سنة';
    }
  }

  String get payAction {
    switch (language) {
      case AppLanguage.ru: return 'Оплатить';
      case AppLanguage.en: return 'Pay';
      case AppLanguage.ar: return 'دفع';
    }
  }

  // --- MyBots ---
  String get myBotsLocked {
    switch (language) {
      case AppLanguage.ru: return 'Войдите чтобы увидеть ваших ботов';
      case AppLanguage.en: return 'Login to see your bots';
      case AppLanguage.ar: return 'سجل الدخول لرؤية بوتاتك';
    }
  }

  String get myBotsEmpty {
    switch (language) {
      case AppLanguage.ru: return 'У вас пока нет подключённых ботов';
      case AppLanguage.en: return 'You have no connected bots yet';
      case AppLanguage.ar: return 'ليس لديك بوتات متصلة بعد';
    }
  }

  String get myBotsGoCatalog {
    switch (language) {
      case AppLanguage.ru: return 'Перейти в каталог';
      case AppLanguage.en: return 'Go to catalog';
      case AppLanguage.ar: return 'الذهاب إلى المتجر';
    }
  }

  // --- Settings ---
  String get setAccount {
    switch (language) {
      case AppLanguage.ru: return 'Аккаунт';
      case AppLanguage.en: return 'Account';
      case AppLanguage.ar: return 'الحساب';
    }
  }

  String get setLanguage {
    switch (language) {
      case AppLanguage.ru: return 'Язык';
      case AppLanguage.en: return 'Language';
      case AppLanguage.ar: return 'اللغة';
    }
  }

  String get setNotifications {
    switch (language) {
      case AppLanguage.ru: return 'Уведомления';
      case AppLanguage.en: return 'Notifications';
      case AppLanguage.ar: return 'الإشعارات';
    }
  }

  String get setAbout {
    switch (language) {
      case AppLanguage.ru: return 'О приложении';
      case AppLanguage.en: return 'About app';
      case AppLanguage.ar: return 'حول التطبيق';
    }
  }

  String get setVersion {
    switch (language) {
      case AppLanguage.ru: return 'Версия';
      case AppLanguage.en: return 'Version';
      case AppLanguage.ar: return 'الإصدار';
    }
  }

  String get setNotifSettings {
    switch (language) {
      case AppLanguage.ru: return 'Настройки уведомлений';
      case AppLanguage.en: return 'Notification settings';
      case AppLanguage.ar: return 'إعدادات الإشعارات';
    }
  }

  // --- Profile ---
  String get profTitle {
    switch (language) {
      case AppLanguage.ru: return 'Профиль';
      case AppLanguage.en: return 'Profile';
      case AppLanguage.ar: return 'الملف الشخصي';
    }
  }

  String get profChangePass {
    switch (language) {
      case AppLanguage.ru: return 'Сменить пароль';
      case AppLanguage.en: return 'Change password';
      case AppLanguage.ar: return 'تغيير كلمة المرور';
    }
  }

  String get profLogout {
    switch (language) {
      case AppLanguage.ru: return 'Выйти из аккаунта';
      case AppLanguage.en: return 'Sign out';
      case AppLanguage.ar: return 'تسجيل الخروج';
    }
  }

  String get profCurrentPass {
    switch (language) {
      case AppLanguage.ru: return 'Текущий пароль';
      case AppLanguage.en: return 'Current password';
      case AppLanguage.ar: return 'كلمة المرور الحالية';
    }
  }

  String get profNewPass {
    switch (language) {
      case AppLanguage.ru: return 'Новый пароль';
      case AppLanguage.en: return 'New password';
      case AppLanguage.ar: return 'كلمة المرور الجديدة';
    }
  }

  String get profRepeatPass {
    switch (language) {
      case AppLanguage.ru: return 'Повторите новый пароль';
      case AppLanguage.en: return 'Repeat new password';
      case AppLanguage.ar: return 'تأكيد كلمة المرور الجديدة';
    }
  }

  String get profCancel {
    switch (language) {
      case AppLanguage.ru: return 'Отмена';
      case AppLanguage.en: return 'Cancel';
      case AppLanguage.ar: return 'إلغاء';
    }
  }

  String get profSave {
    switch (language) {
      case AppLanguage.ru: return 'Сохранить';
      case AppLanguage.en: return 'Save';
      case AppLanguage.ar: return 'حفظ';
    }
  }

  String get profPassMismatch {
    switch (language) {
      case AppLanguage.ru: return 'Пароли не совпадают';
      case AppLanguage.en: return 'Passwords do not match';
      case AppLanguage.ar: return 'كلمات المرور غير متطابقة';
    }
  }

  String get profPassLength {
    switch (language) {
      case AppLanguage.ru: return 'Пароль должен быть минимум 6 символов';
      case AppLanguage.en: return 'Password must be at least 6 characters';
      case AppLanguage.ar: return 'يجب أن تتكون كلمة المرور من 6 أحرف на الأقل';
    }
  }

  String get profPassSuccess {
    switch (language) {
      case AppLanguage.ru: return 'Пароль успешно изменён';
      case AppLanguage.en: return 'Password changed successfully';
      case AppLanguage.ar: return 'تم تغيير كلمة المرور بنجاح';
    }
  }

  // --- Notifications ---
  String get notifPush {
    switch (language) {
      case AppLanguage.ru: return 'Push-уведомления';
      case AppLanguage.en: return 'Push notifications';
      case AppLanguage.ar: return 'إشعارات الدفع';
    }
  }

  String get notifPushSub {
    switch (language) {
      case AppLanguage.ru: return 'Получать уведомления на устройство';
      case AppLanguage.en: return 'Receive notifications on device';
      case AppLanguage.ar: return 'تلقي الإشعارات على الجهاز';
    }
  }

  String get notifEmail {
    switch (language) {
      case AppLanguage.ru: return 'Email-уведомления';
      case AppLanguage.en: return 'Email notifications';
      case AppLanguage.ar: return 'إشعارات البريد';
    }
  }

  String get notifEmailSub {
    switch (language) {
      case AppLanguage.ru: return 'Получать уведомления на почту';
      case AppLanguage.en: return 'Receive notifications by email';
      case AppLanguage.ar: return 'تلقي الإشعارات عبر البريد';
    }
  }

  // --- BotManagement ---
  String get bmTitle {
    switch (language) {
      case AppLanguage.ru: return 'Управление ботом';
      case AppLanguage.en: return 'Bot management';
      case AppLanguage.ar: return 'إدارة البوت';
    }
  }

  String get bmActions {
    switch (language) {
      case AppLanguage.ru: return 'ДЕЙСТВИЯ';
      case AppLanguage.en: return 'ACTIONS';
      case AppLanguage.ar: return 'الإجراءات';
    }
  }

  String get bmAppointments {
    switch (language) {
      case AppLanguage.ru: return 'ЗАПИСИ';
      case AppLanguage.en: return 'APPOINTMENTS';
      case AppLanguage.ar: return 'السجلات';
    }
  }

  String get bmPromptSettings {
    switch (language) {
      case AppLanguage.ru: return 'НАСТРОЙКИ ПРОМПТА';
      case AppLanguage.en: return 'PROMPT SETTINGS';
      case AppLanguage.ar: return 'إعدادات الأوامر';
    }
  }

  String get bmActivateGroup {
    switch (language) {
      case AppLanguage.ru: return 'АКТИВИРОВАТЬ ГРУППУ';
      case AppLanguage.en: return 'ACTIVATE GROUP';
      case AppLanguage.ar: return 'تفعيل المجموعة';
    }
  }

  String get bmActive {
    switch (language) {
      case AppLanguage.ru: return 'Бот активен';
      case AppLanguage.en: return 'Bot active';
      case AppLanguage.ar: return 'البوت مفعل';
    }
  }

  String get bmSetupRequired {
    switch (language) {
      case AppLanguage.ru: return 'Требуется настройка';
      case AppLanguage.en: return 'Setup required';
      case AppLanguage.ar: return 'مطلوب إعداد';
    }
  }

  String get bmReady {
    switch (language) {
      case AppLanguage.ru: return 'Бот готов к приему заказов';
      case AppLanguage.en: return 'Bot ready for orders';
      case AppLanguage.ar: return 'البوت جاهز لتلقي الطلبات';
    }
  }

  String get bmBindGroup {
    switch (language) {
      case AppLanguage.ru: return 'Привяжите Telegram группу';
      case AppLanguage.en: return 'Bind Telegram group';
      case AppLanguage.ar: return 'ربط مجموعة تيليجرام';
    }
  }
}
