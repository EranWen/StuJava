package com.erabay.daoImpl;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
/*import org.hibernate.service.ServiceRegistry;*/

public class CopyOfHibernateSessionFactory {

	private static final String CFG_FILE_LOCATION = "./Hibernate.cfg.xml";

	private static final ThreadLocal<Session> threadLocal = new ThreadLocal<Session>();

	private static final Configuration cfg = new Configuration().configure(CFG_FILE_LOCATION);

	private static StandardServiceRegistryBuilder  builder = new StandardServiceRegistryBuilder ().applySettings(cfg.getProperties());
	
	/*ServiceRegistry sr = new StandardServiceRegistryBuilder().applySettings(conf.getProperties()).build();*/
	
	private static StandardServiceRegistry registry;

	private static SessionFactory sessionFactory;

	public static Session currentSession() throws HibernateException {
		Session session = threadLocal.get();
		System.out.println("currentSession 1111 =:"+session);
		System.out.println("builder 1  =:" + builder);
		System.out.println("sessionFactory 1  =:" + sessionFactory);
		if (session == null || session.isOpen() == false) {

			if (sessionFactory == null) {
				try {
					System.out.println("sessionFactory 0  =:" + sessionFactory);
					/*registry = builder.getBootstrapServiceRegistry();*/
					registry = builder.build();
					sessionFactory = cfg.buildSessionFactory(registry);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			System.out.println("sessionFactory 1  " + sessionFactory);
			session = sessionFactory.openSession();
			threadLocal.set(session);

		}
		System.out.println("sessionFactory 2  " + sessionFactory);
		return session;
	}

	public static void closeSession() throws HibernateException {
		Session session = threadLocal.get();
		threadLocal.set(null);
		if (session != null) {
			session.close();
		}
	}

}
