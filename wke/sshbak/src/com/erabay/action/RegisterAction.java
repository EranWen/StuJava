package com.erabay.action;

import com.opensymphony.xwork2.ActionSupport;
import com.erabay.forms.UserForm;
import com.erabay.service.UserManager;
import com.erabay.serviceImpl.UserManagerImpl;

public class RegisterAction extends ActionSupport {

	private static final long serialVersionUID = 1L;

	private UserForm user;

	private UserManager userManager;

	public UserForm getUser() {
		return user;
	}

	public void setUser(UserForm user) {
		this.user = user;
	}

	public UserManager getUserManager() {
		return userManager;
	}

	public void setUserManager(UserManager userManager) {
		
		this.userManager = userManager;
	}

	public String execute() {
		try {
			System.out.println("RegisterAction execute username:="+user.getUsername());
			this.setUserManager(new UserManagerImpl());
				this.userManager.regUser(user);
				return SUCCESS;

		} catch (Exception e) {
			e.printStackTrace();
			return ERROR;
		}
		
/*		System.out.println("username:"+user.getUsername());
		System.out.println("password:"+user.getPassword());
        if("11".equals(this.user.getUsername()) &&  "11".equals(this.user.getPassword())){
            msg = "µÇÂ¼³É¹¦£¬»¶Ó­" + this.user.getUsername();
            return SUCCESS;
        }else{
            msg = "µÇÂ¼Ê§°Ü£¬ÓÃ»§Ãû»òÃÜÂë´í";
            return ERROR;
        }*/		
	}


}
