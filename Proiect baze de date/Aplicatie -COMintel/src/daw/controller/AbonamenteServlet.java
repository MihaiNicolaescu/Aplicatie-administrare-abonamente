package daw.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import daw.bean.Abonament;
import daw.model.dao.AbonamentDAO;


@SuppressWarnings("serial")
@WebServlet("/abonamente")
public class AbonamenteServlet extends HttpServlet {

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		if(session.getAttribute("loggedUser") != null) {
			ArrayList<Abonament> abonamente = new ArrayList<Abonament>();
			AbonamentDAO abonamentDAO = new AbonamentDAO();
			abonamente = abonamentDAO.getAbonamente();
			request.setAttribute("abonamente", abonamente);
			request.getRequestDispatcher("/WEB-INF/abonamente.jsp").forward(request, response);
		}else if(session.getAttribute("loggedUser") == null) {
			request.getRequestDispatcher("/WEB-INF/login.jsp").forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(request.getParameter("adauga_abonament") != null) { // adaugarea unui abonament
			int cod_abonament = Integer.parseInt(request.getParameter("cod_abonament_field"));
			String denumire = request.getParameter("denumire_field");
			String tip = request.getParameter("tip_field");
			float trafic = Float.parseFloat(request.getParameter("tarfic_field"));
			float pret = Float.parseFloat(request.getParameter("pret_field"));
			float extra = Float.parseFloat(request.getParameter("extra_field"));
			Abonament abonament = new Abonament(cod_abonament, denumire, tip, trafic, pret, extra);
			AbonamentDAO abonamentDAO = new AbonamentDAO();
			
			String result = abonamentDAO.adaugaAbonament(abonament);
			
			if(result == "INVALID") {
				PrintWriter out = response.getWriter();
				out.println("<script type=\"text/javascript\">");
	            out.println("alert('Abonamentul nu poate fi adaugat deoarece exista un abonament care detine acelasi id!');");
	            out.println("window.location.href = \"abonamente\";");
	            out.println("</script>");
			}		
			if(result == "SUCCESS") {
				PrintWriter out = response.getWriter();
				out.println("<script type=\"text/javascript\">");
	            out.println("alert('Abonamentul a fost adaugat cu succes!');");
	            out.println("window.location.href = \"abonamente\";");
	            out.println("</script>");
			}
			
			
		}
		
		if(request.getParameter("delete_abonament") != null) { // stergerea unui abonament
			int id_abonament = Integer.parseInt(request.getParameter("id_abonament"));

			AbonamentDAO abonamentDAO = new AbonamentDAO();
			
			String result = abonamentDAO.stergereAbonament(id_abonament);
			if(result == "INVALID") {
				PrintWriter out = response.getWriter();
				out.println("<script type=\"text/javascript\">");
	            out.println("alert('Abonamentul nu poate fi sters deoarece exista abonati care detin acest abonament!');");
	            out.println("window.location.href = \"abonamente\";");
	            out.println("</script>");
			}		
			if(result == "SUCCESS") {
				PrintWriter out = response.getWriter();
				out.println("<script type=\"text/javascript\">");
	            out.println("alert('Abonamentul a fost sters cu success!');");
	            out.println("window.location.href = \"abonamente\";");
	            out.println("</script>");
			}
			
		}
		
		if(request.getParameter("editare_abonament") != null) { // editarea unui abonament
			int id_abonament = Integer.parseInt(request.getParameter("id_abonament"));
			
			request.getSession().setAttribute("cod_abonament", id_abonament);
			response.sendRedirect("editabonament");
			//request.getRequestDispatcher("/WEB-INF/editareAbonament.jsp").forward(request, response);
			
		}
		
		
	}

}
