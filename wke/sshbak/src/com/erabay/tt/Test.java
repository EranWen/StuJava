package com.erabay.tt;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

public class Test {

    public static void main(String[] args) {

        try {
            SessionFactory sf = new Configuration().configure().buildSessionFactory();
            Session session = sf.openSession();
            Transaction tx = session.beginTransaction();

            for (int i = 0; i < 20; i++) {
                Customer customer = new Customer();
                customer.setUsername("Test" + i); //$NON-NLS-1$
                customer.setPassword("Test1"); //$NON-NLS-1$
                session.save(customer);
            }

            tx.commit();
            session.close();

        } catch (HibernateException e) {
            e.printStackTrace();
        } 
        System.out.println("finish 20 rows");
   }
}
