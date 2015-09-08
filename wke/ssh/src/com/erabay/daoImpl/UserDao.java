package com.erabay.daoImpl;

import org.hibernate.FlushMode;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.springframework.orm.hibernate4.support.HibernateDaoSupport;

import com.erabay.dao.BaseDao;

public class UserDao extends HibernateDaoSupport implements BaseDao {
	
	Session session = null;

	public void saveObject(Object obj) throws HibernateException {
		
		session = getSessionFactory().getCurrentSession();
        session = getSessionFactory().openSession();
        session.setFlushMode(FlushMode.MANUAL);
        session.save(obj);

	}

}
