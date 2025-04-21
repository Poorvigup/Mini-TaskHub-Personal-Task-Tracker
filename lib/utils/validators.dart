class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateTaskTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Task title cannot be empty';
    }
     if (value.length > 100) { 
      return 'Title is too long (max 100 chars)';
    }
    return null;
  }

  static String? validateName(String? value) {
     if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
     if (value.length < 2) {
       return 'Please enter a valid name';
     }
      if (value.length > 50) {
       return 'Name is too long (max 50 chars)';
     }
     return null;
  }
}