import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {
  @Input() searchTerm: string = ''; 
  @Output() searchTermChange: EventEmitter<string> = new EventEmitter<string>(); 
  isMobileMenuOpen: boolean = false; 
  constructor(private router: Router) {}

  toggleMobileMenu() {  
    this.isMobileMenuOpen = !this.isMobileMenuOpen;  
  } 

  onSearchTermChange(): void {
    this.searchTermChange.emit(this.searchTerm);
  }
}
