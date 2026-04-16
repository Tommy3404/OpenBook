//
//  ReadTimeTrackerView.swift
//  OpenBook
//
//  Created by Tommy McClure on 3/3/26.
//

import SwiftUI

struct ReadTimeTrackerView: View {
    
    @Binding var name: String
    @Binding var isLoggedIn: Bool
    
    var updateName: (String) -> Void
    
    @State private var showMenu = false
    
    // MARK: - Stopwatch Properties
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer? = nil
    @State private var isRunning = false
    @State private var startTime: Date? = nil
    
    // MARK: - Book Title
    @State private var bookTitle: String = ""
    
    // MARK: - Manual Entry Popup
    @State private var showManualEntryPopup = false
    @State private var manualBookTitle: String = ""
    @State private var manualStartTime: Date = Date()
    @State private var manualEndTime: Date = Date()
    
    // MARK: - Deletion Confirmation
    @State private var sessionToDelete: ReadingSession?
    @State private var showDeleteConfirmation = false
    
    // MARK: - Reading Session Model
    struct ReadingSession: Identifiable {
        let id = UUID()
        let title: String
        let duration: TimeInterval
        let date: Date
    }
    
    @State private var sessions: [ReadingSession] = []
    
    // MARK: - Grid Layout
    private let gridColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // MARK: - App Theme Colors
    private let backgroundColor = Color(red: 250/255, green: 243/255, blue: 224/255)
    private let accentColor = Color(red: 235/255, green: 213/255, blue: 195/255)
    private let primaryColor = Color(red: 166/255, green: 124/255, blue: 82/255)
    private let cardColor = Color.white
    
    var body: some View {
        
        ZStack(alignment: .topTrailing) {
            
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // ✅ SPACE ADDED FOR HEADER
                    Spacer().frame(height: 70)
                    
//                    Text("Read Time Tracker Page")
//                        .font(.title2)
//                        .foregroundColor(primaryColor)
                    
                    // MARK: - Book Title Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Book Title")
                            .font(.headline)
                            .foregroundColor(primaryColor)
                        
                        TextField("Enter book title...", text: $bookTitle)
                            .padding()
                            .background(cardColor)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Stopwatch Section
                    VStack(spacing: 15) {
                        Text("Stopwatch")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(formatTime(elapsedTime))
                            .font(.system(size: 42, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 15) {
                            Button("Start", action: startTimer)
                                .frame(width: 80)
                                .buttonStyle(.borderedProminent)
                                .tint(primaryColor)
                                .disabled(isRunning)
                            
                            Button("Stop", action: stopTimer)
                                .frame(width: 80)
                                .buttonStyle(.borderedProminent)
                                .tint(primaryColor)
                                .disabled(!isRunning)
                            
                            Button("Reset", action: resetTimer)
                                .frame(width: 80)
                                .buttonStyle(.bordered)
                                .tint(.white)
                        }
                    }
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    
                    // MARK: - Manual Entry Button
                    HStack {
                        Spacer()
                        Button {
                            manualBookTitle = bookTitle
                            manualStartTime = Date()
                            manualEndTime = Date()
                            showManualEntryPopup = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(primaryColor)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Sessions
                    if !sessions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack {
                                Text("Reading Sessions")
                                    .font(.headline)
                                    .foregroundColor(primaryColor)
                                Spacer()
                                
                                Button("Clear") {
                                    sessions.removeAll()
                                }
                                .foregroundColor(.red)
                            }
                            
                            LazyVGrid(columns: gridColumns, spacing: 16) {
                                ForEach(sessions) { session in
                                    
                                    ZStack(alignment: .topTrailing) {
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(session.title)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                            
                                            Text(formatTime(session.duration))
                                                .foregroundColor(.white)
                                                .font(.system(.subheadline, design: .monospaced))
                                            
                                            Text(formatDate(session.date))
                                                .foregroundColor(.white.opacity(0.85))
                                                .font(.caption2)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
                                        .background(primaryColor)
                                        .cornerRadius(12)
                                        
                                        Button {
                                            sessionToDelete = session
                                            showDeleteConfirmation = true
                                        } label: {
                                            Image(systemName: "trash.fill")
                                                .foregroundColor(primaryColor)
                                                .padding(6)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .padding(6)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
            
            // MARK: - Header (FIXED)
        }
        .overlay(alignment: .top) {
            HeaderView(
                title: "Read Time Tracker",
                currentPage: "Tracker",
                showMenu: $showMenu,
                isLoggedIn: $isLoggedIn,
                updateName: updateName
            )
            .zIndex(999)
        }
        
        // MARK: - Sheet
        .sheet(isPresented: $showManualEntryPopup) {
            ManualTimeEntryView(
                isPresented: $showManualEntryPopup,
                bookTitle: $manualBookTitle,
                startTime: $manualStartTime,
                endTime: $manualEndTime,
                primaryColor: primaryColor,
                backgroundColor: backgroundColor
            ) { title, start, end in
                
                var duration = end.timeIntervalSince(start)
                if duration < 0 { duration += 86400 }
                
                saveSession(
                    title: title.isEmpty ? "Untitled Book" : title,
                    duration: duration
                )
            }
        }
        
        .alert("Delete Session?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                if let session = sessionToDelete {
                    deleteSession(session)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        
        .navigationBarBackButtonHidden(true)
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - Stopwatch Functions
    
    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = startTime {
                elapsedTime += Date().timeIntervalSince(start)
                startTime = Date()
            }
        }
    }
    
    func stopTimer() {
        guard isRunning else { return }
        
        isRunning = false
        timer?.invalidate()
        timer = nil
        startTime = nil
        
        let trimmedTitle = bookTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalTitle = trimmedTitle.isEmpty ? "Untitled Book" : trimmedTitle
        
        saveSession(title: finalTitle, duration: elapsedTime)
    }
    
    func resetTimer() {
        stopTimer()
        elapsedTime = 0
    }
    
    // MARK: - Session Management
    
    func saveSession(title: String, duration: TimeInterval) {
        guard duration > 0 else { return }
        sessions.insert(
            ReadingSession(title: title, duration: duration, date: Date()),
            at: 0
        )
    }
    
    func deleteSession(_ session: ReadingSession) {
        withAnimation {
            sessions.removeAll { $0.id == session.id }
        }
    }
    
    // MARK: - Formatting Helpers
    
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ReadTimeTrackerView(
            name: .constant("Tommy"),
            isLoggedIn: .constant(true),
            updateName: { _ in }
        )
    }
}

// MARK: - Manual Time Entry Popup

struct ManualTimeEntryView: View {
    
    @Binding var isPresented: Bool
    @Binding var bookTitle: String
    @Binding var startTime: Date
    @Binding var endTime: Date
    
    var primaryColor: Color
    var backgroundColor: Color
    
    var onSave: (String, Date, Date) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Book Title")) {
                    TextField("Enter book title", text: $bookTitle)
                }
                
                Section(header: Text("Start Time")) {
                    DatePicker("Start",
                               selection: $startTime,
                               displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("End Time")) {
                    DatePicker("End",
                               selection: $endTime,
                               displayedComponents: .hourAndMinute)
                }
            }
            .scrollContentBackground(.hidden)
            .background(backgroundColor)
            .navigationTitle("Manual Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .tint(primaryColor)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(bookTitle, startTime, endTime)
                        isPresented = false
                    }
                    .tint(primaryColor)
                    .fontWeight(.semibold)
                }
            }
        }
        .tint(primaryColor)
    }
}
