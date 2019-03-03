Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Knock::Engine => "/knock"

  # Home controller routes.
  # root   'home#index'
  # get    'auth'            => 'home#auth'
  
  
  namespace :api do
    namespace :v1 do
      # Get login token from Knock
      post   'user_token'      => 'user_token#create'

      # User actions
      get    '/userList'       => 'users#get_userlist'
      get    '/users/current'  => 'users#current'
      get    '/first_subuser_list' => 'users#first_subuser_list'
      get    '/all_subuser_me_list' => 'users#all_subuser_me_list'
      post   '/userList'       => 'users#post_userlist'
      patch  '/userList'       => 'users#patch_userlist'
      delete '/userList'       => 'users#delete_userlist'
      get    '/userpass'       => 'users#get_userpass'
      patch  '/userpass'       => 'users#patch_userpass'
      # resources :users, only: [:index, :current, :create, :update, :destroy]

      # Authority actions
      get    '/authRuleList'   =>  'authorities#get_rulelist'
      post   '/authRuleList'   =>  'authorities#post_rulelist'
      delete '/authRuleList'   =>  'authorities#delete_rulelist'
      patch  '/authRuleList'   =>  'authorities#patch_rulelist'
      
      get    '/user_group_list'=>  'authorities#get_user_group_list'

      get    '/authGroupList'  =>  'authorities#get_grouplist'
      post   '/authGroupList'  =>  'authorities#post_grouplist'
      delete '/authGroupList'  =>  'authorities#delete_grouplist'
      patch  '/authGroupList'  =>  'authorities#patch_grouplist'

      get    '/authUserList'   =>  'authorities#get_userlist'
      patch  '/authUserList'   =>  'authorities#patch_userlist'

      # Teacher actions
      get        '/teacherList'    =>  'teachers#get_teacherlist'
      post       '/teacherList'    =>  'teachers#post_teacherlist'
      patch      '/teacherList'    =>  'teachers#patch_teacherlist'
      delete     '/teacherList'    =>  'teachers#delete_teacherlist'

      get        '/teachercourseList'  =>  'teachers#get_teachercourselist'
      patch      '/teachercourseList'  =>  'teachers#patch_teachercourselist'

      # get        '/termList'        =>  'teachers#get_termlist'
      post       '/tccList'         =>  'teachers#post_tcclist'
      patch      '/tccList'         =>  'teachers#patch_tcclist'

      # Student actions
      get        '/studentList'    =>  'students#get_studentlist'
      post       '/studentList'    =>  'students#post_studentlist'
      patch      '/studentList'    =>  'students#patch_studentlist'
      delete     '/studentList'    =>  'students#delete_studentlist'

      post       '/classStu'       =>  'students#get_classstu'
      patch      '/classStu'       =>  'students#post_classstu'
      delete     '/classStu'       =>  'students#delete_classstu'

      post       '/manystudent'    =>  'students#post_manystudent'

      # ClassRoom actions
      get        '/classroomList'    =>  'class_rooms#get_classroomlist'
      post       '/classroomList'    =>  'class_rooms#post_classroomlist'
      patch      '/classroomList'    =>  'class_rooms#patch_classroomlist'
      delete     '/classroomList'    =>  'class_rooms#delete_classroomlist'

      get        '/classcourseList'  =>  'class_rooms#get_classcourselist'
      patch      '/classcourseList'  =>  'class_rooms#patch_classcourselist'

      # Course actions
      get        '/courseList'    =>  'courses#get_courselist'
      post       '/courseList'    =>  'courses#post_courselist'
      patch      '/courseList'    =>  'courses#patch_courselist'
      delete     '/courseList'    =>  'courses#delete_courselist'

      get        '/courseevalList'  =>  'courses#get_courseevallist'
      patch      '/courseevalList'  =>  'courses#patch_courseevallist'

      # Evaluation actions
      get        '/evaluationList1'   =>  'evaluations#get_evaluationlist'
      post       '/evaluationList'    =>  'evaluations#post_evaluationlist'
      patch      '/evaluationList'    =>  'evaluations#patch_evaluationlist'
      delete     '/evaluationList'    =>  'evaluations#delete_evaluationlist'

      get        '/get_termList_e'    =>  'evaluations#get_termlist_e'
      # ClassGradeInput actions
      post       'tcourseList'     =>  'class_grade_input#get_tcourselist'
      post       'tclassList'      =>  'class_grade_input#post_tclasslist'
      patch      'inputclassgrade' =>  'class_grade_input#inputclassgrade'
      post       'get_classgrade'  =>  'class_grade_input#get_classgrade'

      get        'studentgradeList' =>  'class_grade_input#studentgradeList'

      #Term actions
      get        '/termList'    =>  'terms#get_termlist'
      post       '/termList'    =>  'terms#post_termlist'
      patch      '/termList'    =>  'terms#patch_termlist'

      #Homework actions
      get        '/tea_homework'  =>  'homeworks#get_hw_eva'
      post       '/tea_homework'  =>  'homeworks#post_hw_eva'
      patch      '/tea_homework'  =>  'homeworks#patch_hw_eva'

      get        '/stu_homework'  =>  'homeworks#get_hw'
      post       '/stu_homework'  =>  'homeworks#post_hw'
      patch      '/stu_homework'  =>  'homeworks#patch_hw'

      get        '/stu_homework_by_id'  =>  'homeworks#get_hw_by_id'

    end
  end

end
