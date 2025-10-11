package com.example.student.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.student.model.Student;
import com.example.student.repo.StudentRepository;

/*
 * This Service is to fetch Student details
 * 
 */

@Service
public class StudentService {
	
	@Autowired
	private StudentRepository repository;
	
	
	public Student findById(int id){
		
		Optional<Student> optStu = repository.findById(id);
		
		return optStu.orElseThrow();
	}
	
	public Student findByName(String name){
		return repository.findByName(name).orElseThrow();
	}
	
	public List<Student> findAllByNAme(String name){
		return repository.findAllByName(name);
	}
	
	public Student createStudent(Student student) {
		return repository.save(student);
	}

}
