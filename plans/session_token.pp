plan bolt_train::session_token(
  TargetSpec $targets,
  String[1] $email
 ){
   $token_result = run_task('bolt_train::session', $targets, 'email' => $email)
   return $token_result[0].value['token']
 }
