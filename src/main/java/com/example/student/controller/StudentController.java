package com.example.student.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.student.model.Student;
import com.example.student.service.StudentService;



@RestController
@RequestMapping("/students")
public class StudentController {
	
	@Autowired
	private StudentService service;
	
	@GetMapping("/by-id/{id}")
	public Student getStudentById(@PathVariable("id") int id){
		return service.findById(id);
		
	}
	
	@GetMapping("/by-name")
	public Student getStudentByName(@RequestParam("name") String name){
		return service.findByName(name);
		
	}
	
	@PostMapping
	public Student createStudent(@RequestBody Student student){
		return service.createStudent(student);	
	}
	
	

}
