package scheduler;

import dal.ClassroomDAO;

public class ClassCodeJob implements Runnable {

    @Override
    public void run() {
        try {
            ClassroomDAO clsDAO = new ClassroomDAO();
            //clear expiry class code 
            clsDAO.clearExpiredClassCode();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
