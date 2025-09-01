package com.exaample.student.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.when;

import java.util.Optional;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.example.student.model.Student;
import com.example.student.repo.StudentRepository;
import com.example.student.service.StudentService;

public class StudentServiceTest {
	
	
	@Mock
	private StudentRepository repository;
	
	@InjectMocks
	private StudentService service; 
	
	@BeforeEach
	public void init() {
		MockitoAnnotations.openMocks(this);
	}
	
	@Test
	public void get_student_by_id() {
		Student student = new Student();
		student.setId(1);
		student.setName("Smanjas");
		student.setRollNo("23");
		
		when(repository.findById(anyInt())).thenReturn(Optional.of(student));
		
		Student optResult = service.findById(1);
		
		assertEquals(1, optResult.getId());
		
		
	}

}
