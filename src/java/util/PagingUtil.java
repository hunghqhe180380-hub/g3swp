/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import dal.UserDAO;

/**
 *
 * @author BINH
 */
public class PagingUtil {
    private int size, nrpp, index;

    public PagingUtil() {
    }

    public PagingUtil(int size, int nrpp, int index) {
        this.size = size;
        this.nrpp = nrpp;
        this.index = index;
    }
    private int totalPage, start, end, pageStart, pageEnd;

    public PagingUtil(int totalPage, int start, int end, int pageStart, int pageEnd) {
        this.totalPage = totalPage;
        this.start = start;
        this.end = end;
        this.pageStart = pageStart;
        this.pageEnd = pageEnd;
    }
    
    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public int getNrpp() {
        return nrpp;
    }

    public void setNrpp(int nrpp) {
        this.nrpp = nrpp;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public int getStart() {
        return start;
    }

    public void setStart(int start) {
        this.start = start;
    }

    public int getEnd() {
        return end;
    }

    public void setEnd(int end) {
        this.end = end;
    }

    public int getPageStart() {
        return pageStart;
    }

    public void setPageStart(int pageStart) {
        this.pageStart = pageStart;
    }

    public int getPageEnd() {
        return pageEnd;
    }

    public void setPageEnd(int pageEnd) {
        this.pageEnd = pageEnd;
    }
    public void calc(){
        totalPage = (size+nrpp-1)/nrpp;
        index = index<0?0:index;         
        index = totalPage>0&&index>=totalPage?totalPage-1:index;
        start = index*nrpp;
        end = start+nrpp-1;
        end = end>=size?size-1:end;
        end = end<0?0:end;
        pageStart = index-2<0?0:index-2;
        pageEnd = index+2>totalPage-1?totalPage-1:index+2;
        pageEnd = pageEnd<0?0:pageEnd;
    }
    
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        int size = dao.getAllUsers().size();
        System.out.println(size);        
    }
}
