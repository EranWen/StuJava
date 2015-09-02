package com.erabay.serviceImpl;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.erabay.beans.User;
import com.erabay.dao.BaseDao;
import com.erabay.daoImpl.HibernateSessionFactory;
import com.erabay.daoImpl.UserDao;
import com.erabay.forms.UserForm;
import com.erabay.service.UserManager;

public class UserManagerImpl implements UserManager {

	private BaseDao dao;

	private Session session;

	public UserManagerImpl() {
		dao = new UserDao();
		System.out.println("UserManagerImpl dao getSession :="+dao.getSession());
	}

	@Override
	public void regUser(UserForm userForm) throws HibernateException {
		System.out.println("UserManagerImpl regUser :="+userForm.getUsername());
		System.out.println("UserManagerImpl HibernateSessionFactory =:"+dao.getSession());
		session = HibernateSessionFactory.currentSession();
		System.out.println("UserManagerImpl HibernateSessionFactory1 :="+dao.getSession());
		dao.setSession(session);
		// ��ȡ����
		Transaction ts = session.beginTransaction();
		// ����User����
		User user = new User();
		user.setUsername(userForm.getUsername());
		user.setPassword(userForm.getPassword());
		user.setGender(userForm.getGender());
		/*user.setUserId(userForm.getGender());*/
		// ����User����
		System.out.println("UserManagerImpl password:="+user.getPassword());
		System.out.println("Username:="+user.getUsername());
		System.out.println("UserId:="+user.getUserId());
		System.out.println("Gender:="+user.getGender());
		dao.saveObject(user);
		System.out.println("dao");
		// �ύ����
		ts.commit();
		// �ر�Session
		HibernateSessionFactory.closeSession();
	}

}
