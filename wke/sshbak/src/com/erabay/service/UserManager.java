package com.erabay.service;

import org.hibernate.HibernateException;

import com.erabay.forms.UserForm;

public interface UserManager {

	public void regUser(UserForm user) throws HibernateException;

}
